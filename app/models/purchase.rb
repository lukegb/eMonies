class Purchase < ActiveRecord::Base
  validates :name, presence: true
  validates :amount, presence: true
  validates :amount, numericality: true
  validates :person_id, presence: true

  belongs_to :person
  has_many :acceptances

  default_scope { order('date DESC') }

  def self.dealtwith
    self.all.includes(:acceptances).select do |p|
      accepted = false
      p.acceptances.each do |a|
        accepted = true
        break
      end

      accepted
    end
  end

  def accepted_by_me(current_person)
    self.acceptances.each do |a|
      if a.person == current_person then
        return a.amount
      end
    end
    return nil
  end

  def accepted_total
    self.acceptances.reduce(0) do |acc, a|
      acc + (a.amount.nil? ? 0 : a.amount)
    end
  end
end
