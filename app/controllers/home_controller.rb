class HomeController < ApplicationController
  def index
  end

  def about_us
    
  end

  def test
  	@test= Customer.find(1)
  	@vendors= Vendor.all
  	@goods= MallGood.all
  end

  def search

    @first_class= MallCategory.where(:level=>1)
    @second_class= MallCategory.where(:level=>2)

    @key= params[:search_key]
    @flag=1
    if @flag==1
      @goods= search_service(@key)
      @key_goods= @goods.page(params[:page])
    elsif @flag==2
    end

  end


  def search_service( key)
    MallGood.where("title like '%#{key}%'")
  end

  def research_goods_by_category
    @first_class= MallCategory.where(:level=>1)
    @second_class= MallCategory.where(:level=>2)
    @category_id= params[:id]
    @key= params[:key]
    #@goods=MallGood.all
    @goods=MallGood.where("title like '%#{@key}%' and mall_category_id= '#{@category_id}' ")
    @key_goods= @goods.page(params[:page])
  end

  def test1
  end

  def card
  end
end
