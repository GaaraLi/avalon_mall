class VendorsController < ApplicationController
	layout 'vendor'
  def index
    @vendors=Vendor.all
    @page_vendors= @vendors.page(params[:page])
    @page_title="车行列表"
    @bread_crumbs=['车行列表', vendors_path]
  end

  def show
    @vendor = Vendor.find(params[:id])
    @first_class= MallCategory.where(:level=>1)
    @second_class= MallCategory.where(:level=>2)
    @category_id= params[:id]
    @vendor_goods= Vendor.find(params[:id]).mall_goods.onsale
    @key_vendor_goods= @vendor_goods.page(params[:page])

    @page_title="#{@vendor.name}"
  end

  def research_vendor_goods_by_category
    @vendor = Vendor.find(params[:id])
    @category_id= params[:key_id]
    if 0!=@category_id.to_i
      @vendor_goods = MallGood.find_by_sql("select g.id, g.mall_category_id, g.title, g.logo_url1,g.mall_sku_id from mall_goods g, mall_categories c,vendors v
                                          where g.mall_category_id = #{@category_id} and v.id= #{params[:id]} and g.vendor_id= v.id").uniq
    else
      @vendor_goods= @vendor.mall_goods
    end
    @first_class= MallCategory.where(:level=>1)
    @second_class= MallCategory.where(:level=>2)

    @key_vendor_goods=  Kaminari.paginate_array(@vendor_goods).page(params[:page])
  end

  def map
    @type = params[:type];
    if @type.present?
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
      @vendors=Vendor.where("id>0")
      @page_vendors= @vendors.page(params[:page])
    when 1
      @vendors=Vendor.where("mall_area_id=1")
      @page_vendors= @vendors.page(params[:page])
    when 2
      @vendors=Vendor.where("mall_area_id=2")
      @page_vendors= @vendors.page(params[:page])
    when 3
      @vendors=Vendor.where("mall_area_id=3")
      @page_vendors= @vendors.page(params[:page])
    when 4
      @vendors=Vendor.where("mall_area_id=4")
      @page_vendors= @vendors.page(params[:page])
    when 5
      @vendors=Vendor.where("mall_area_id=5")
      @page_vendors= @vendors.page(params[:page])
    when 6
      @vendors=Vendor.where("mall_area_id=6")
      @page_vendors= @vendors.page(params[:page])
    else
    end

  end
end
