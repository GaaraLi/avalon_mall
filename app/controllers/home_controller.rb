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


    @nav_label_check= 1
    @key= params[:search_key]
  end

  def about_us
    @shown_id= params[:id]
  end

  def test
  	@test= Customer.find(1)
  	@vendors= Vendor.onmall.all
  	@goods= MallGood.all
  end

  def search
    @first_class= MallCategory.where(:level=>1)
    @second_class= MallCategory.where(:level=>2)

    @key= params[:search_key]
    @flag= params[:search_type].to_i
    @first_show= 0

    if @flag==1
      @page_title="产品搜索"
      @goods= search_service(@key)
      @key_goods= @goods.page(params[:page])
      @first_show= 1
    elsif @flag==2
      @page_title="产品搜索"
      @vendors= search_vendor( @key)
      @page_vendors = @vendors.page(params[:page])
    elsif @flag==0
      @page_title="全部商品"
      @goods=MallGood.all.onsale
      @key_goods= @goods.page(params[:page])
      @first_show= 0
    elsif @flag==3
      @page_title="全部商品"
      @goods= MallGood.all.onsale
      @key_goods= @goods.page(params[:page])
      @first_show= 3
    elsif @flag==4
      @page_title="产品搜索"
      @goods= search_service_from_homepage(@key.to_i)
      @key_goods= @goods.page(params[:page])
      @category_id = @key
      @first_show= 0
    end

    @good_hot_rec= MallBlock.where("mall_block_type_id=15")
    @good_hot_rec1= MallBlock.where("mall_block_type_id=14")

  end

  def search_service_from_homepage(key)
    MallGood.onsale.where("mall_category_id = #{key} ")
  end

  def search_vendor( key)
    Vendor.onmall.where("name like '%#{key}%'")
  end

  def search_service( key)
    MallGood.where("title like '%#{key}%'").order(" id DESC").onsale
  end

  def research_goods_by_category
    @first_class= MallCategory.where(:level=>1)
    @second_class= MallCategory.where(:level=>2)
    @category_id= params[:id]
    @key= params[:key]
    @flag= params[:order_flag]
    @first_show= params[:first_show].to_i

    #from anywhere when the click the category list
    # from homepage left the first time 
    if @first_show == 0
      case @flag.to_i
      when 1
        @goods=MallGood.includes(:mall_skus).where(" mall_category_id= '#{@category_id}' ")
        
      when 2
        @goods=MallGood.includes(:mall_skus).where(" mall_category_id= '#{@category_id}' ").order("mall_skus.sale_count ")
        
      when 3
        @goods=MallGood.includes(:mall_skus).where(" mall_category_id= '#{@category_id}' ").order("mall_skus.show_price ")
        
      when 4
        @goods=MallGood.includes(:mall_skus).where(" mall_category_id= '#{@category_id}' ").order("mall_skus.show_price DESC")
        
      else
        @goods=MallGood.includes(:mall_skus).where(" mall_category_id= '#{@category_id}' ")
        
      end
    #from top search label the first time
    elsif @first_show ==1
      case @flag.to_i
      when 1
        @goods=MallGood.includes(:mall_skus).where("title like '%#{@key}%' ")
        
      when 2
        @goods=MallGood.includes(:mall_skus).where("title like '%#{@key}%' ").order("mall_skus.sale_count ")
        
      when 3
        @goods=MallGood.includes(:mall_skus).where("title like '%#{@key}%' ").order("mall_skus.show_price ")
        
      when 4
        @goods=MallGood.includes(:mall_skus).where("title like '%#{@key}%' ").order("mall_skus.show_price DESC")
        
      else
        @goods=MallGood.includes(:mall_skus).where("title like '%#{@key}%' ")
        
      end
    #all goods the first time
    elsif @first_show ==2
      case @flag.to_i
      when 1
        @goods=MallGood.all.onsale.includes(:mall_skus)
        
      when 2
        @goods=MallGood.all.onsale.includes(:mall_skus).order("mall_skus.sale_count ")
        
      when 3
        @goods=MallGood.all.onsale.includes(:mall_skus).order("mall_skus.show_price ")
        
      when 4
        @goods=MallGood.all.onsale.includes(:mall_skus).order("mall_skus.show_price DESC")
        
      else
        @goods=MallGood.all.onsale.includes(:mall_skus)
        
      end
    #all goods the first time
    elsif @first_show ==3
      case @flag.to_i
      when 1
        @goods=MallGood.all.onsale.includes(:mall_skus)
        
      when 2
        @goods=MallGood.all.onsale.includes(:mall_skus).order("mall_skus.sale_count ")
        
      when 3
        @goods=MallGood.all.onsale.includes(:mall_skus).order("mall_skus.show_price ")
        
      when 4
        @goods=MallGood.all.onsale.includes(:mall_skus).order("mall_skus.show_price DESC")
        
      else
        @goods=MallGood.all.onsale.includes(:mall_skus)
        
      end
=begin    # from homepage left the first time 
    elsif @first_show ==4 
      case @flag.to_i
      when 1
        @goods=MallGood.all.onsale.includes(:mall_skus)
        
      when 2
        @goods=MallGood.all.onsale.includes(:mall_skus).order("mall_skus.sale_count DESC")
        
      when 3
        @goods=MallGood.all.onsale.includes(:mall_skus).order("mall_skus.show_price DESC")
        
      when 4
        @goods=MallGood.all.onsale.includes(:mall_skus).order("mall_skus.show_price")
        
      else
        @goods=MallGood.all.onsale.includes(:mall_skus)
        
      end
=end
    end

    @key_goods= @goods.page(params[:page])
  end

  def test1
  end

  def card
      @page_title="享车卡"
      @nav_label_check= 3
  end

end
