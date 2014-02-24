class Customer <ActiveRecord::Base
  include ApplicationHelper
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :timeoutable #, :confirmable
end