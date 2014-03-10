class Customer <ActiveRecord::Base
  include ApplicationHelper
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :timeoutable #, :confirmable
  has_one :card
  has_one :car
  has_one :transfer_code
  has_one :withdraw_cash
  has_one :third_party_customer
  has_many :transactions
  has_many :extra_consumption_records
end