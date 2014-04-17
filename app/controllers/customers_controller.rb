class CustomersController < ApplicationController
  include ApplicationHelper
  include AlipayHelper
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_customer!, :except=>[:index,:show,:notify_page,:success_page]

  def del_shopping_car
    @shopping_car_id_string= params[:data]
    @shopping_car_id_array= @shopping_car_id_string.split(",")
    if @shopping_car_id_array.respond_to?("each")
      @shopping_car_id_array.each { |id|
        MallShoppingCar.delete(id.to_i)
      }
    else
      MallShoppingCar.delete(@shopping_car_id_array.to_i)
    end
    render :json=>1
  end

  def shopping_car
    @cart_list= current_customer.mall_shopping_cars
    @bread_crumbs=["购物车"]
    @page_title="我的购物车"
  end

  def order_page
    @cart_ids= params[:selected_ids]
    @cart_ids=@cart_ids.split(",").map{|i| i.to_i}
    @cart_orders= MallShoppingCar.find( @cart_ids )
    @bread_crumbs=["购物车"]
    @page_title="我的购物车"
  end

  def check_inventory
    @ids= params[:ids]
    @all_quantity= params[:all_quantity]
    @all_quantity_array= @all_quantity.scan(/[^ ]+/)

    @ids= @ids.delete("[").delete("]").split(",")
    @ids.zip(@all_quantity_array).each do |id,q|
      @shopping_car_line= MallShoppingCar.find(id.to_i)
      if (@shopping_car_line.mall_sku.mall_inventory.inventory_qty<=0)
        render :json=>0
        return
      end
      @price= current_customer.get_price(@shopping_car_line.mall_sku).to_i * q.to_i
      @shopping_car_line.update_attributes(:quantity=> q, :price=>@price, :original_price=>@price)
    end
    render :json=>1
  end

  def set_order_time_list
    @order_times= params[:time_list]
    current_customer.update_attributes(:customer_order_times=>@order_times)
    render :json=>1
  end

  def cart_confirm
    @cart_ids= params[:selected_ids]
    @order_times_list= params[:selected_times]
    current_customer.update_attributes(:customer_order_times=>@order_times_list )
    puts '==========in cat_confirm'
    puts current_customer.customer_order_times

    @order_number= new_order_number
    
    @input_name= params[:input_name]
    @input_phone= params[:input_phone]
    @input_car= params[:input_car]

    @order_order= MallOrder.create(:order_no=> @order_number,:status=> 0,
                                   :customer_id=>current_customer.id,
                                   :input_name=> @input_name,
                                   :input_phone=> @input_phone,
                                   :input_car=>@input_car)
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
    puts ' in success_page================='
    puts payment_succeed?
    puts @order.paid( params, request.raw_post)
    if payment_succeed? && @order.paid( params, request.raw_post)
      flash[:notice] = '恭喜，您已续费成功'
      if @order.status == 0
        @order.update_attributes(status: 1, finish_time: Time.now.strftime("%Y-%m-%d-%H:%M:%S") )
         puts ' after update================='

        @current_customer= Customer.find(@order.customer_id)
        # new exchange code
        @mall_order_lines= @order.mall_order_lines if (@order!= nil)
        new_exchange_code_line( @mall_order_lines,@current_customer)
         puts ' after exchange code line================='

        #repaid
        do_order_repaid(@current_customer, @order) if @current_customer.card
         puts ' after do_order_repaid================='
       end
      redirect_to "http://m.ixiangche.com/customers/center"
    else
      flash[:error] = '支付失败！请检查您的支付操作是否成功'
      render customers_error_page_path
    end
  end

  def do_order_repaid(c, o)
    @current_customer= c
    if @current_customer.card.repaid_time >= @current_customer.card.repaid_tactic_customer.times
      return true
    end
    
    if @current_customer.card.vendor_binding_record
      @price= get_binding_vendor_price( c, o)
    else
      @price= 0
    end
    if ( @price>= @current_customer.card.repaid_tactic_customer.consumption_amount )
       repaid= get_repaid( @price,@current_customer )
       return true if !repaid

       #repaid history
       add_repaid_info( @current_customer.card.id, @price, repaid)

       #related info
       related_info( @current_customer.card.id, repaid)

    end
    return true
  end
  def add_repaid_info( card_id, consumption, repaid)
    repaid_info= RepaidHistory.new
    card= Card.find( card_id)
    repaid_info.card_id= card.id
    repaid_info.consumption_amount= consumption
    repaid_info.repaid_amount= repaid
    repaid_info.vendor_id = card.vendor_binding_record.vendor_id
    repaid_info.repaid_tactic_customer_id= Card.find(card_id).repaid_tactic_customer_id
    if repaid_info.save
      #
    else
      puts 'save failed'
      return
    end
  end

  def get_repaid( price, c)
    @current_customer= c
    customer_id= @current_customer.id
    @tactic_id= c.card.repaid_tactic_customer_id
    @repaid_tactic= RepaidTacticCustomer.find(:first, :conditions=>["expired=0 and start_rule=1 and id>=#{@tactic_id} "])
    if check_date( customer_id)
      if price >= @repaid_tactic.consumption_amount
        return @repaid_tactic.repaid_amount
      else
        while 0 !=@repaid_tactic.next_rule
          @repaid_tactic= RepaidTacticCustomer.find(@repaid_tactic.next_rule)
          return @repaid_tactic.repaid_amount if price>= @repaid_tactic.consumption_amount
        end
        return false
      end
    else
      @default_repaid_tactic= RepaidTacticCustomer.find(:first, :conditions=>["expired=0 and duration=0"])
      if price>= @default_repaid_tactic.consumption_amount
        return @default_repaid_tactic.repaid_amount
      else
        return false
      end
    end
  end
  def related_info( card_id, repaid)
    card= Card.find( card_id)
    repaid_time= card.repaid_time
    repaid_time= repaid_time+1
    card.update_attribute(:repaid_time, repaid_time)

    customer= Customer.find( card.customer_id)
    cash= customer.cash_account+ repaid
    customer.update_attribute(:cash_account, cash)
  end

  def check_date( customer_id)
    @now_time = Time.now.strftime("%Y-%m-%d");
    @renewal = Renewal.find(:all, :conditions=>[" customer_id = ? and renewal_start <= ? and renewal_end >= ?",customer_id,@now_time,@now_time])
    if @renewal.length == 1
      @renewal_start = @renewal[0].renewal_start.to_date >> 3
      if @renewal_start.to_s >= @now_time.to_s
        return true
      else
        return false
      end
    else
      return false
    end
  end
  def get_binding_vendor_price(c, o)
    @current_customer= c
    price=0
    o.mall_order_lines.each do |l|
      if l.vendor_id== @current_customer.card.vendor_binding_record.vendor_id
        price= price+ l.price
      end
    end
    return price
  end

  def new_exchange_code_line( lines,c)
    lines.zip( c.customer_order_times.scan(/[^,]+/)).each do |l,t|

      l.quantity.times do
        @code= create_exchange_code
        MallExchange.create( :exchange_code_number=> @code, :mall_order_line_id=> l.id, :order_time=>time )
      end
      # @q>0
      @q= l.mall_sku.mall_inventory.inventory_qty- l.quantity
      l.mall_sku.mall_inventory.update_attributes(:inventory_qty=> @q)

      #add sale number
      @s= l.mall_sku.sale_count+ l.quantity
      l.mall_sku.update_attributes(:sale_acount=> @s)

    end
    return true
  end

  def create_exchange_code
    #translate the date into second from 1970 then add the usec
    @n= rand(9999999..100000000)
    if MallExchange.find_by_exchange_code_number( @n)
      create_exchange_code
    else
      @n
    end

  end

  def notify_page
    @order = MallOrder.find( params[:extra_common_param])
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
    puts '=====add_into_cart====='
    puts q
    puts s

    @price= order_line_price( q, s)
    puts '=====add_into_cart====='
    puts @price

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
    @s= MallSku.find(s.to_i)
    p= current_customer.get_price(@s)
    @price= p*q.to_i
    @price
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

  def allcarbrand
    render :json => CarBrand.all
  end

  def carbrand
    @car_brand = CarBrand.find(params[:id])
    render :json => @car_brand.car_sets.to_a
  end

  def carset
    @car_set = CarSet.find(params[:id])
    render :json => @car_set.car_models.to_a
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
