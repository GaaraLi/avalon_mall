class TransferCode < ActiveRecord::Base
	has_many :transfer_customers
	belongs_to :customer
end
