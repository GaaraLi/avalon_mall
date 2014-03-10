class Car < ActiveRecord::Base
  belongs_to :customer
  belongs_to :car_model

  def get_brand
    if self.car_model.present?
  	  self.car_model.car_set.car_brand.name.split(" ").last
    else
      return "其他"
    end
  end

  def get_set
    if self.car_model.present?
  	  self.car_model.car_set.name.split(" ").last
    else
      return "其他"
    end
  end

  def get_model
    if self.car_model.present?
  	  self.car_model.name
    else
      return "其他"
    end
  end
end
