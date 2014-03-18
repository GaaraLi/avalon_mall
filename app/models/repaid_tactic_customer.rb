class RepaidTacticCustomer < ActiveRecord::Base
	has_many :cards
	has_many :repaid_histories
end
