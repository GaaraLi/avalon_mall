class CustomersController < ApplicationController
  before_filter :authenticate_customer!
end
