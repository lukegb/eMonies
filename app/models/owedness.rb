require 'AmountMultiplier'

class Owedness < ActiveRecord::Base
  belongs_to :from_person, class_name: :Person
  belongs_to :to_person, class_name: :Person

  def self.owes(to, from)
    s = self.find_by(to_person_id: to.id, from_person_id: from.id)
    return s.amount unless s.nil?
    0
  end

  include AmountMultiplier
end
