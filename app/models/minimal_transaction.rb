require 'AmountMultiplier'

class MinimalTransaction < ActiveRecord::Base
  belongs_to :from_person, class_name: :Person
  belongs_to :to_person, class_name: :Person

  include AmountMultiplier
end
