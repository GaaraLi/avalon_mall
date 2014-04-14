class ExtraServiceDetail < ActiveRecord::Base
  belongs_to :extra_service_type
  has_many :extra_consumption_records
  has_many :consumption_appointments
end