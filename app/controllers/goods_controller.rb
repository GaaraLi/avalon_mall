class GoodsController < ApplicationController
	def show
      @good = MallGood.find(params[:id])
	end
end
