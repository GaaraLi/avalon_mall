class HomeController < ApplicationController
  def index
    @homepage_sliders= MallBlock.where("mall_block_type_id=1")
    @homepage_slider_right= MallBlock.where("mall_block_type_id=2")
    @homepage_slider_right_links= MallBlock.where("mall_block_type_id=11")
    @homepage_recommends= MallBlock.where("mall_block_type_id=4")
    @first_class= MallCategory.where(:level=>1)
    @second_class= MallCategory.where(:level=>2)

    @new_rec_goods=  MallBlock.where("mall_block_type_id=6")
    @hot_rec_goods=  MallBlock.where("mall_block_type_id=5")
    @rec_vendors=  MallBlock.where("mall_block_type_id=7")

    @card_area= MallBlock.where("mall_block_type_id=3").first
    @adv_area= MallBlock.where("mall_block_type_id=8").first
    puts '=========='
    puts @adv_area.img_url

    @nav_label_check= 1
  end

  def about_us
    @shown_id= params[:id]
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
    @flag= params[:search_type].to_i

    if @flag==1
      @page_title="产品搜索"
      @goods= search_service(@key)
      @key_goods= @goods.page(params[:page])
    elsif @flag==2
      @page_title="车行搜索"
      @vendors= search_vendor(@key)
      @page_vendors = @vendors.page(params[:page])
    elsif @flag==0
      @goods=MallGood.all.onsale
      @key_goods= @goods.page(params[:page])
      @page_title="全部商品"
    end

    @good_hot_rec= MallBlock.where("mall_block_type_id=15")
    @good_hot_rec1= MallBlock.where("mall_block_type_id=14")

  end

  def search_vendor( key)
    Vendor.where("name like '%#{key}%'")
  end

  def search_service( key)
    MallGood.where("title like '%#{key}%'").onsale
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
      @page_title="享车卡"
      @nav_label_check= 3
  end

end
