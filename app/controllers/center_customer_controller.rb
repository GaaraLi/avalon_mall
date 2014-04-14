class CenterCustomerController < ApplicationController
  before_filter :center_customer
  def center_customer
    if !current_customer.present?
    	redirect_to("/");
    end
  end
end
