class Renewal < ActiveRecord::Base
  belongs_to :customer
  belongs_to :transaction
end
