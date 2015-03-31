module PurchasesHelper
  # Borrowed from https://stackoverflow.com/questions/9144822/how-to-declare-a-two-dimensional-array-in-ruby.
  # Extended by myself
  class SparseArray
    attr_reader :hash

    def initialize
      @hash = {}
    end

    def [](key)
      hash[key] ||= {}
    end

    def rows
      hash.length
    end

    def merge!(others)
      @hash.merge!(others.hash) do |key, oldval, newval|
        oldval + newval
      end
    end

    def key?(key)
      @hash.key?(key)
    end

    def deep_copy
      d = SparseArray.new
      out_hash = d.hash
      @hash.each do |to, froms|
        out_hash[to] = {}
        froms.each do |from, val|
          out_hash[to][from] = val
        end
      end
      d
    end

    alias_method :length, :rows
  end

  def self.calculate_books!(d, push_owednesses)
    person_books = {}

    #Iterate over the triangular form
    d.hash.each do |to, froms|
      froms.each do |from, amount|

        # Store this in the caching table Owednesses
        Owedness.new(from_person: Person.find(from), to_person: Person.find(to), amount: amount).save! if push_owednesses
        Owedness.new(from_person: Person.find(to), to_person: Person.find(from), amount: -amount).save! if push_owednesses

        person_books[to] = 0 unless person_books.key? to
        person_books[from] = 0 unless person_books.key? from

        person_books[from] -= amount
        person_books[to] += amount
      end
    end

    person_books
  end

  def self.simplify_owednesses(d)
    d = d.deep_copy

    d.hash.each do |to, froms|
      froms.keys.each do |from|
        if d[from].key?(to) then
          if d.key?(to) && d[to].key?(from) then
            d[from][to] -= d[to][from]
            d[to][from] = 0
          end
        end
      end
    end

    d
  end

  def self.calculate_transactions(person_books)
    transactions = []

    negative_people = {}
    positive_people = {}

    person_books.each do |p, balance|
      if balance < 0 then
        negative_people.store p, balance
      else
        positive_people.store p, balance
      end
    end

    positive_people.each do |to, exp|
      next if exp == 0
      negative_people.each do |from, possible|
        amt = (exp < -possible) ? exp : -possible
        transactions.push Hash[from: from, to: to, amount: amt]
        negative_people[from] += amt
        exp -= amt
        negative_people.delete(from) if negative_people[from] == 0
      end
    end

    transactions
  end

  def self.recalculate_owes!
    dbg = {}

    n_people = Person.all.size

    # Use a nxn array structure, in row -> column order. rows are who paid for an item, columns are the amount owed by the others to that person.
    # The diagonal will (by definition) always be zero. Implemented using a SparseArray, so that memory usage is not large
    d = SparseArray.new
    people_set = Person.all.to_set

    Person.all.each do |p|
      Person.all.each do |p2|
        next if p == p2 or d.key?(p2)

        d[p.id][p2.id] = 0
        d[p2.id][p.id] = 0
      end
    end

    # start generating the speculative version too
    specd = d.deep_copy
    specd_is_different = false

    Purchase.all.each do |p|
      total_balance = p.amount
      accepted_by = Set.new

      #As this item was paid for by p.person, they are owed the money listed in acceptances by the others (might include themselves).
      p.acceptances.each do |a|
        accepted_by.add(a.person)
        total_balance -= a.amount

        #If there is an acceptance from p.person to p.person, then consider this a spend of money, and don't update owednesses (you can't owe yourself)
        next if a.person == p.person

        d[p.person.id][a.person.id] = (d[p.person.id][a.person.id].nil? ? 0 : d[p.person.id][a.person.id]) + a.amount
        specd[p.person.id][a.person.id] = (specd[p.person.id][a.person.id].nil? ? 0 : specd[p.person.id][a.person.id]) + a.amount
      end

      if total_balance > 0 then
        # go through each person who hasn't accepted yet
        pending_people = people_set - accepted_by
        balance_per_person = total_balance / pending_people.size
        pending_people.each do |person|
          next if person == p.person

          specd[p.person.id][person.id] = (specd[p.person.id][person.id].nil? ? 0 : specd[p.person.id][person.id]) + balance_per_person
          specd_is_different = true
        end
      end
    end

    dbg[:raw] = d.clone
    dbg[:raw_spec] = specd.clone

    dbg[:simplified] = []

    # Now, we need to simplify the resulting owednesses, so that when A owes B, and B owes A, we just need one transaction to fix this.
    # This will generate a triangular matrix
    d = self.simplify_owednesses(d)
    specd = self.simplify_owednesses(specd) if specd_is_different

    Owedness.delete_all

    dbg[:person_books] = []

    #Iterate over the triangular form
    person_books = self.calculate_books!(d, true)
    spec_person_books = self.calculate_books!(specd, false) if specd_is_different

    # Calculate the minimum possible transactions to fix this
    transactions = self.calculate_transactions(person_books)
    spec_transactions = self.calculate_transactions(spec_person_books) if specd_is_different

    dbg[:minimal] = transactions

    # Store the required transactions
    MinimalTransaction.delete_all
    transactions.each { |trans| MinimalTransaction.new(from_person: Person.find(trans[:from]), to_person: Person.find(trans[:to]), amount: trans[:amount], speculative: false).save! }
    spec_transactions.each { |trans| MinimalTransaction.new(from_person: Person.find(trans[:from]), to_person: Person.find(trans[:to]), amount: trans[:amount], speculative: true).save! } if specd_is_different

    true

    dbg
  end
end
