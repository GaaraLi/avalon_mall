class CustomersController < ApplicationController
  include ApplicationHelper
  include AlipayHelper
  before_filter :authenticate_customer!

  def shopping_car
  end

  def order_page
  end

  def success_page
    if payment_succeed?
      flash[:notice] = '恭喜，您已续费成功'
      redirect_to customers_center_path
    else
      flash[:error] = '支付失败！请检查您的支付操作是否成功'
      render customers_error_path
    end
  end

  def error_page
    
  end

  def center
  end

  def buy
    @good_quantity=params[:input_hidden_name].to_i
    @good_sku= params[:good_sku]
    @good_sku= MallSku.find(@good_sku)
  end

  def order_confirm
    @good_quantity=params[:good_quantity].to_i
    @good_sku= params[:good_sku]
    @mall_order=new_order( @good_quantity, @good_sku)
    redirect_to "#{to_alipay_good}"

  end

  def new_order( quantity, sku)
    @order_number= new_order_number
    @order_order= MallOrder.create(:order_no=> @order_number,:status=> 0,:customer_id=>current_customer.id)
    @mall_order_id= @order_order.id
    new_order_line( quantity, sku, @mall_order_id)
    return @order_order
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
    @price= MallSku.find(s).show_price*q.to_i
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

end
