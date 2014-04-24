class VendorsController < ApplicationController
	layout 'vendor'
  def index
    @vendors=Vendor.onmall.all
    @page_vendors= Kaminari.paginate_array(@vendors).page(params[:page])
    @page_title="车行列表"
    @bread_crumbs=['车行列表', vendors_path]
    @nav_label_check= 2
    @good_hot_rec= MallBlock.where("mall_block_type_id=15")
    @good_hot_rec1= MallBlock.where("mall_block_type_id=14")
    @first_class= MallCategory.where(:level=>1)
    @second_class= MallCategory.where(:level=>2)
  end

  def show
    @vendor = Vendor.find(params[:id])
    @vendor_map= @vendor.to_json(:include => [:address], :methods => :main_photo)
    @first_class= MallCategory.where(:level=>1)
    @second_class= MallCategory.where(:level=>2)
    @category_id= params[:id]
    @vendor_goods= Vendor.find(params[:id]).mall_goods.onsale
    @key_vendor_goods= @vendor_goods.page(params[:page])
    @good_hot_rec= MallBlock.where("mall_block_type_id=15")

    @page_title="#{@vendor.name}"
  end

  def research_vendor_goods_by_category
    @vendor = Vendor.find(params[:id])
    @category_id= params[:key_id]
    if 0!=@category_id.to_i
      @vendor_goods = MallGood.find_by_sql("select g.id, g.mall_category_id, g.title, g.logo_url1 from mall_goods g, mall_categories c,vendors v where g.mall_category_id = #{@category_id} and v.id= #{params[:id]} and g.vendor_id= #{params[:id]} ").uniq
    else
      @vendor_goods= @vendor.mall_goods.onsale
    end
    @first_class= MallCategory.where(:level=>1)
    @second_class= MallCategory.where(:level=>2)

    @key_vendor_goods=  Kaminari.paginate_array(@vendor_goods).page(params[:page])
  end

  def map
    #@type = params[:type];
    @type= nil
    if @type
      @vendors = Vendor.find(:all,:conditions=>["id in (5,21,22,6,23,11,16,24)"]);
    else
      @vendors = Vendor.find(:all,:conditions=>["id != 13 and id !=25"])
    end
    @vendors.reject! { |vendor|
      vendor.address.nil?
    }
    @vendors.reject! { |vendor|
      vendor.address.latitude.nil?
    }
    @vendors = @vendors.to_json(:include => [:address], :methods => :main_photo)
  end

  def vendor_search
    flag= params[:id]
    case flag.to_i
    when 0
      @vendors=Vendor.onmall.where("id>0")
      @page_vendors= @vendors.page(params[:page])
    when 1
      @vendors=Vendor.onmall.where("mall_area_id=1")
      @page_vendors= @vendors.page(params[:page])
    when 2
      @vendors=Vendor.onmall.where("mall_area_id=2")
      @page_vendors= @vendors.page(params[:page])
    when 3
      @vendors=Vendor.onmall.where("mall_area_id=3")
      @page_vendors= @vendors.page(params[:page])
    when 4
      @vendors=Vendor.onmall.where("mall_area_id=4")
      @page_vendors= @vendors.page(params[:page])
    when 5
      @vendors=Vendor.onmall.where("mall_area_id=5")
      @page_vendors= @vendors.page(params[:page])
    when 6
      @vendors=Vendor.onmall.where("mall_area_id=6")
      @page_vendors= @vendors.page(params[:page])
    else
    end

  end

  def vendor_catgory

    @cat_id= params[:cat_id].to_i
    @vendor=Vendor.onmall.find( params[:vendor_id])
    @vendor_map= @vendor.to_json(:include => [:address], :methods => :main_photo)
    @first_class= MallCategory.where(:level=>1)
    @second_class= MallCategory.where(:level=>2)
    @vendor_goods= @vendor.mall_goods.onsale.map{ |g|
      next if g.mall_category.parent_code.to_i != @cat_id
      g
    }.compact

    @key_vendor_goods= Kaminari.paginate_array(@vendor_goods).page(params[:page])
    @good_hot_rec= MallBlock.where("mall_block_type_id=15")

    @page_title="#{@vendor.name}"
  end
end
