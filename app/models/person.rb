class Person < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :lockable

  validates :password, confirmation: true
  validates :name, presence: true
  validates :account_number, numericality: true
  validates :account_number, length: { is: 8 }
  validates :sort_code, numericality: true
  validates :sort_code, length: { is: 6 }

  has_many :purchases
  has_many :acceptances, :through => :purchases
end
