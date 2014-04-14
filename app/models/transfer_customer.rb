class TransferCustomer < ActiveRecord::Base
	belongs_to :transfer_code
	belongs_to :customer
end
