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

    alias_method :length, :rows
  end

  def self.recalculate_owes!
    n_people = Person.all.size

    # Use a nxn array structure, in row -> column order. rows are who paid for an item, columns are the amount owed by the others to that person.
    # The diagonal will (by definition) always be zero. Implemented using a SparseArray, so that memory usage is not large
    d = SparseArray.new

    Purchase.all.each do |p|
      #As this item was paid for by p.person, they are owed the money listed in acceptances by the others (might include themselves).
      p.acceptances.each do |a|
        #If there is an acceptance from p.person to p.person, then consider this a spend of money, and don't update owednesses (you can't owe yourself)
        next if a.person == p.person

        d[p.person.id][a.person.id] = (d[p.person.id][a.person.id].nil? ? 0 : d[p.person.id][a.person.id]) + a.amount
      end
    end

    # Now, we need to simplify the resulting owednesses, so that when A owes B, and B owes A, we just need one transaction to fix this.
    # This will generate a triangular matrix
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

    Owedness.delete_all

    person_books = {}

    #Iterate over the triangular form
    d.hash.each do |to, froms|
      froms.each do |from, amount|

        # Store this in the caching table Owednesses
        o = Owedness.new(from_person: Person.find(from), to_person: Person.find(to), amount: amount)
        o.save!
        oi = Owedness.new(from_person: Person.find(to), to_person: Person.find(from), amount: -amount)
        oi.save!

        person_books[to] = 0 unless person_books.key? to
        person_books[from] = 0 unless person_books.key? from

        person_books[from] -= amount
        person_books[to] += amount

      end
    end

    # Calculate the minimum possible transactions to fix this
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
        negative_people[from] -= amt
        negative_people.delete(from) if negative_people[from] == 0
      end
    end

    # Store the required transactions
    MinimalTransaction.delete_all
    transactions.each { |trans| MinimalTransaction.new(from_person: Person.find(trans[:from]), to_person: Person.find(trans[:to]), amount: trans[:amount]).save! }

    true
  end
end
