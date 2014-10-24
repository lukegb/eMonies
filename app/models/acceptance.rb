class Acceptance < ActiveRecord::Base
  validates :amount, numericality: {only_integer: false}
  validates :amount, presence: true
  validates :person_id, presence: true
  validates :person_id, :uniqueness => { :scope => :purchase_id }
  validates :purchase_id, presence: true

  belongs_to :person
  belongs_to :purchase

  def amount
    (read_attribute(:amount) || 0)/100.to_f
  end

  def amount=(value)
    write_attribute(:amount, (value.to_f*100).to_i)
  end
end
