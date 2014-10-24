require 'AmountMultiplier'

class Acceptance < ActiveRecord::Base
  validates :amount, numericality: {only_integer: false, greater_than: 0}
  validates :amount, presence: true
  validates :person_id, presence: true
  validates :person_id, :uniqueness => { :scope => :purchase_id }
  validates :purchase_id, presence: true

  belongs_to :person
  belongs_to :purchase

  include AmountMultiplier
end
