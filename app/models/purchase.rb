require 'AmountMultiplier'

class Purchase < ActiveRecord::Base
  validates :name, presence: true
  validates :amount, presence: true
  validates :amount, numericality: {only_integer: false, greater_than: 0}
  validates :person_id, presence: true

  belongs_to :person
  has_many :acceptances

  include AmountMultiplier

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

  def requires_action_by_me?(current_person)
    not self.accepted_by_me(current_person) and not self.accepted_total == self.amount
  end

  def pending_other_acceptances?(current_person)
    not self.requires_action_by_me?(current_person) and self.person == current_person and not self.accepted_total == self.amount
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
