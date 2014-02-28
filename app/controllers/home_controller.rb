class HomeController < ApplicationController
  def index
  end

  def test
  	@test= Customer.find(1)
  	@vendors= Vendor.all
  	@goods= MallGood.all
  end

  def search

  end
  def test1

  end
end
