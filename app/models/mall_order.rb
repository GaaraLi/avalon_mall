class MallOrder < ActiveRecord::Base
  include ApplicationHelper
  require 'open-uri'
  belongs_to :vendor
  belongs_to :customer
  has_many   :mall_order_lines

  def paid( params, request_post)
    if Rails.env.production?
      return false unless from_alipay?(params[:notify_id])
    end
    if status == 0
      update_attributes(status: 1, finish_time: Time.now.strftime("%Y-%m-%d-%H:%M:%S") )

      # new exchange code
      @mall_order_lines= mall_order_lines if (mall_order_lines!= nil)
      new_exchange_code_line( @mall_order_lines)

      #repaid
      @current_customer= Customer.find(customer_id)
      do_order_repaid if @current_customer.card
    end
    return true
  end

  def new_exchange_code_line( lines)
    lines.zip( ApplicationHelper::get_order_times.scan(/[^,]+/)).each do |l,t|
      time,times=""
      if t.include?"尚未预约"
        tt=""
      else
        tt= t.scan(/[^X]+/)
        tt.each_slice(2) do |a,b|
          time = a.to_s
          times= b.to_i
        end
      end
      l.quantity.times.each do |l|
        @code= create_exchange_code
        if times>0
          MallExchange.create( :exchange_code_number=> @code, :mall_order_line_id=> l.id, :order_time=>time )
          times -=1
        else
          MallExchange.create( :exchange_code_number=> @code, :mall_order_line_id=> l.id )
        end
      end
      # @q>0
      @q= l.mall_sku.mall_inventory.inventory_qty- l.quantity
      l.mall_sku.mall_inventory.update_attributes(:inventory_qty=> @q)
    end

    return true
  end

  def do_order_repaid
    @current_customer= Customer.find(customer_id)
    if @current_customer.card.repaid_time >= @current_customer.card.repaid_tactic_customer.times
      return true
    end
    
    if @current_customer.card.vendor_binding_record
      @price= get_binding_vendor_price
    else
      @price= 0
    end
    if ( @price>= @current_customer.card.repaid_tactic_customer.consumption_amount )
       repaid= get_repaid( @price)
       return true if !repaid

       #repaid history
       add_repaid_info( @current_customer.card.id, @price, repaid)

       #related info
       related_info( @current_customer.card.id, repaid)

    end
    return true
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

  def add_repaid_info( card_id, consumption, repaid)
    repaid_info= RepaidHistory.new
    card= Card.find( card_id)
    repaid_info.card_id= card.id
    repaid_info.consumption_amount= consumption
    repaid_info.repaid_amount= repaid
    repaid_info.repaid_tactic_customer_id= Card.find(card_id).repaid_tactic_customer_id
    if repaid_info.save
      #
    else
      puts 'save failed'
      return
    end
  end

  def get_repaid( price)
    @current_customer= Customer.find(customer_id)
    customer_id= @current_customer.id
    @tactic_id= Customer.find(customer_id).card.repaid_tactic_customer_id
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

  def get_binding_vendor_price
    @current_customer= Customer.find(customer_id)
    price=0
    mall_order_lines.each do |l|
      if l.vendor_id== @current_customer.card.vendor_binding_record.vendor_id
        price= price+ l.price
      end
    end
    return price
  end

  private
  def from_alipay?(notify_id)
    uri = "https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{ActiveMerchant::Billing::Integrations::Alipay::ACCOUNT}&notify_id=#{notify_id}"

    html_response = nil
    open(uri) do |http|
      html_response = http.read
    end
    html_response == 'true'
    #html_response= 'true'
  end

  def create_exchange_code
    #translate the date into second from 1970 then add the usec
    @n= rand(9999999..100000000)
    if MallExchange.find_by_exchange_code( @n)
      create_exchange_code
    else
      @n
    end

  end


end
