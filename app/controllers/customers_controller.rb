class CustomersController < ApplicationController
  include ApplicationHelper
  include AlipayHelper
  before_filter :authenticate_customer!, :except=>[:index,:show]

  def shopping_car
    @cart_list= current_customer.mall_shopping_cars
  end

  def order_page
    @cart_ids= params[:selected_ids]
    @cart_ids=@cart_ids.split(",").map{|i| i.to_i}
    @cart_orders= MallShoppingCar.find( @cart_ids )
  end

  def cart_confirm
    @cart_ids= params[:selected_ids]

    @order_number= new_order_number
    @order_order= MallOrder.create(:order_no=> @order_number,:status=> 0,:customer_id=>current_customer.id)
    @mall_order_id= @order_order.id
    @cart_ids= @cart_ids.delete("[").delete("]").split(",")
    @cart_ids.each do |id|
      @shopping_car_line= MallShoppingCar.find( id.to_i)
      new_order_line( @shopping_car_line.quantity, @shopping_car_line.mall_sku_id, @mall_order_id)
      MallShoppingCar.destroy(id.to_i)
    end
    @mall_order=MallOrder.find( @mall_order_id)

    redirect_to "#{to_alipay_good(@mall_order)}"
  end


  def success_page
    @order = MallOrder.find( params[:extra_common_param])
    if payment_succeed? && @order.paid( params, request.raw_post)
      flash[:notice] = '恭喜，您已续费成功'
      redirect_to customers_center_path

    else
      flash[:error] = '支付失败！请检查您的支付操作是否成功'
      render customers_error_page_path
    end
  end

  def notify_page
    @order = MallOrder.find( params[:extra_common_param])
    @order= MallOrder.find(params[:extra_common_param])
    if @order.paid( params, request.raw_post)
      render :text=>'success'
    else
      render :text=>'failure'
    end
  end

  def error_page

  end

  def center
    @cart_list= current_customer.mall_shopping_cars
  end

  def buy
    @good_quantity=params[:input_hidden_name].to_i
    @good_sku= params[:good_sku]
    @good_sku= MallSku.find(@good_sku)
  end

  def add_in_shopping_car
    @quantity= params[:quantity]
    @mall_sku_id= params[:mall_sku_id]

    add_into_cart( @quantity, @mall_sku_id)

    render :json=>1
  end

  def add_into_cart( q, s)
    @price= order_line_price( @quantity, @mall_sku_id)
    @vendor_id= MallSku.find( s).mall_good.vendor.id

    @new_cart_line= MallShoppingCar.create(:price=> @price,
                                           :original_price=> @price,
                                           :quantity=> q,
                                           :mall_sku_id=> s,
                                           :customer_id=> current_customer.id,
                                           :vendor_id=> @vendor_id)
  end

  def order_confirm
    @good_quantity=params[:good_quantity].to_i
    @good_sku= params[:good_sku]
    @mall_order=new_order( @good_quantity, @good_sku)
    @mall_order=MallOrder.find( @mall_order.id)
    redirect_to "#{to_alipay_good( @mall_order)}"
  end

  def new_order( quantity, sku)
    @order_number= new_order_number
    @order_order= MallOrder.create(:order_no=> @order_number,:status=> 0,:customer_id=>current_customer.id)
    @mall_order_id= @order_order.id
    new_order_line( quantity, sku, @mall_order_id)
    @order_order
  end

  def new_order_line( q, s, o)
    @order_line_price= order_line_price( q, s)
    @order_line=MallOrderLine.create(:original_price=> @order_line_price,
                                     :quantity=>q,
                                     :price=>@order_line_price,
                                     :mall_sku_id=>s,
                                     :mall_order_id=>o,
                                     :customer_id=> current_customer.id,
                                     :vendor_id=>MallSku.find(s).mall_good.vendor.id )
    update_order_info( @order_line_price, q, o)
  end

  def update_order_info( p, q, o)
    @order= MallOrder.find( o)
    @order.update_attributes( :original_price=>p.to_i+@order.original_price.to_i,
                              :price=>p.to_i+@order.original_price.to_i,
                              :quantity=> q.to_i+@order.quantity.to_i)
  end

  def order_line_price( q, s)
    @price= MallSku.find(s).customer_price*q.to_i
  end

  def new_order_number
    #translate the date into second from 1970 then add the usec
    t= Time.now
    n=""
    [t.usec.to_s,t.to_i.to_s].map{|tt|
      n= tt+n
    }
    return "XA"+n
  end

  private

  def payment_succeed?
    ActiveMerchant::Billing::Integrations::Alipay::Return.new(request.query_string).success?
  end

  def load_order
    @order = MallOrder.find( params[:extra_common_param])
    if @order.nil?
      flash[:error] = "找不到订单 #{params[:extra_common_param]}，请联系客服"
      redirect_to customer_center_path
    end
  end

end
