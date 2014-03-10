class CarSet < ActiveRecord::Base
  has_many :car_models
  belongs_to :car_brand
end
