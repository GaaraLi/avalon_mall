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
  has_many :mall_shopping_cars
  has_many :extra_consumption_records

  def get_price( g)
    if self.card.status=="actived" ||self.card.status=="paid"
      g.customer_price.to_i
    else
      g.price.to_i
    end
  end

end