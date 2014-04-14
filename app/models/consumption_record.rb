class ConsumptionRecord < ActiveRecord::Base
  belongs_to :vendor_binding_record
  belongs_to :service
  belongs_to :vendor
end
