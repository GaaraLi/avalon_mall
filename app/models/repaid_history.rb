class RepaidHistory < ActiveRecord::Base
	belongs_to :repaid_tactic_customer
	belongs_to :card
end
