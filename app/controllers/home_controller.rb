class HomeController < ApplicationController
  def index
  end

  def test
  	@test= Customer.find(1)
  end
end
