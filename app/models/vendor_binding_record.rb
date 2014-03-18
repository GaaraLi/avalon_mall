class VendorBindingRecord < ActiveRecord::Base
  belongs_to :card
  belongs_to :vendor
  has_many :services, :through => :consumption_records
  has_many :consumption_records


  def consumption_record_oncard_for(service_id)
    consumption_records.where(service_id: service_id, consumed_by_card: true)
  end
end
