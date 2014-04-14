class WithdrawCash < ActiveRecord::Base
	#has_many :withdraw_cash_records
	belongs_to :customer
end
