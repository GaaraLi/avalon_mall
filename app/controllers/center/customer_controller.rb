class Center::CustomerController < CenterCustomerController
  layout "customer_center"
  protect_from_forgery :except => :index  
  # you can disable csrf protection on controller-by-controller basis:  
  skip_before_filter :verify_authenticity_token  

  def order

    @pageIndex = params[:h_pageIndex].to_i;
    @pageCount = 1;
    if @pageIndex == nil || @pageIndex == "" || @pageIndex <= 0
      @pageIndex = 1;
    end 
    @pageIndexSQL = (@pageIndex-1)*@pageCount ;

    @orders = MallOrder.where("customer_id="+current_customer.id.to_s).limit(@pageIndexSQL.to_s+","+@pageCount.to_s);

    @orders_count = MallOrder.where("customer_id="+current_customer.id.to_s).count;

    @sumCount = 0;
    if @orders_count.to_i == 0
      @sumCount = 1;
    else
      if @orders_count.to_i % @pageCount == 0
        @sumCount = @orders_count/@pageCount.to_i;
      else
        @sumCount = @orders_count/@pageCount.to_i+1;
      end
    end

  end

  def update_order_time
    @h_id = params[:h_id];
    @time = URI.unescape(params[:time]);
    if MallExchange.find(@h_id).update_attributes(:order_time=>@time)
      render :text => '{"flag":"1","content":"预约成功"}'; 
    else
      render :text => '{"flag":"0","content":"预约失败"}'; 
    end
  end

  def account_info
  	@customer = current_customer;
  	@card = @customer.card;
  	@car = @customer.car;
    get_wash_info();
    
  end

  def update_pwd
    
  end

  def update_cus_pwd
  	@pwd = URI.unescape(params[:pwd]);
  	@old_pwd = URI.unescape(params[:old_pwd]);
   
    if !current_customer.valid_password?(@old_pwd)
      render :text => '{"flag":"0","content":"原始密码不正确"}'
      return;
    end

    @cus = Customer.find(current_customer.id);    
    @cus.password=@pwd
    @cus.password_confirmation=@pwd
    if @cus.save 
      render :text => '{"flag":"1","content":"修改密码成功"}'  
      return;
    else
      render :text => '{"flag":"0","content":"修改密码失败"}'
      return;
    end
  end

  def car_wash
    # @today = Time.new.strftime("%Y-%m-%d");
    # @days = (Time.now.strftime("%Y-%m-%d").to_date - current_customer.card.activated_date.strftime("%Y-%m-%d").to_date).to_i
    # @renewal = Renewal.find(:all,:conditions=>["customer_id = ? and renewal_start <= ? and renewal_end >= ?",current_customer.id,@today,@today]);
    #在此卡有效期内本月 本应可以洗多少次(不算已洗次数)
    # @total_month_count = get_total_month_count(@renewal[0].renewal_start,@today);
    #在此卡有效期内一共洗了多少次
    # @used_month_count = get_used_month_count(current_customer.card.id,@renewal[0].renewal_start,@today);

    # @this_month_wash = 0;
    # if @total_month_count - @used_month_count > 0
    #   @this_month_wash = @total_month_count - @used_month_count;      
    # end
    @consumption_records = [];
    if current_customer.card.vendor_binding_record.present?
      @consumption_records = current_customer.card.vendor_binding_record.consumption_records.order("created_at desc");
    end
  end

  def consumption
    @extra_consumption_record = ExtraConsumptionRecord.where("customer_id="+current_customer.id.to_s);
  end

  def cash_account
    @customer = current_customer;
    @sum_rh_price = RepaidHistory.select("sum(repaid_amount) as price").where("card_id="+@customer.card.id.to_s);
    @wcs = WithdrawCash.where("customer_id="+@customer.id.to_s).order("created_at desc");
    @rhs = RepaidHistory.where("card_id="+@customer.card.id.to_s).order("created_at desc");
    @transfer_code = TransferCode.where("customer_id="+@customer.id.to_s);
    if @transfer_code.present?
      @sum_tc_count = @transfer_code[0].transfer_customers.count;
      @tcs = @transfer_code[0].transfer_customers.order("created_at desc");;
    end
    @sum_price = WithdrawCash.select("sum(price) as sum_price").where(["status = 0 and customer_id = ?", @customer.id]);
  end

  def add_withdraw_cash
    @customer = current_customer;

    # @config = SystemConfig.find(:all,:conditions=>["app_key = 'WITHDRAW_CASH'"]);
    # if @config[0].app_value.to_s != "0"
    #   render :text => '{"flag":"0","content":"对不起，现金提取活动已结束"}';
    #   return
    # end
    # @cash_count = WithdrawCash.find(:all,:conditions=>["status = 0 and customer_id =?",@cus_id]).count;
    # if @cash_count != 0
    #   render :text => '{"flag":"0","content":"对不起，您已申请过本次现金提取，请等待下次"}';
    #   return
    # end
    @sum_price = WithdrawCash.select("ifnull(sum(price),0) as sum_price").where("status = 0 and customer_id="+@customer.id.to_s);
    
    @price = URI.unescape(params[:price]);
    @bank_no = URI.unescape(params[:bank_no]);
    @bank_card_name = URI.unescape(params[:bank_card_name]);
    @bank_name = URI.unescape(params[:bank_name]);
    @id_card = URI.unescape(params[:id_card]);
    @mobile_phone = URI.unescape(params[:mobile_phone]);

    if @customer.cash_account.to_i < @price.to_i + @sum_price[0].sum_price.to_i
      render :text => '{"flag":"0","content":"账户余额不够"}';
      return
    end

    withdrawCash = WithdrawCash.new
    withdrawCash.customer_id = @customer.id;
    withdrawCash.status = "0"
    withdrawCash.id_card = @id_card
    withdrawCash.bank_no = @bank_no
    withdrawCash.bank_card_name = @bank_card_name
    withdrawCash.bank_name = @bank_name
    withdrawCash.mobile_phone = @mobile_phone
    withdrawCash.price = @price
    withdrawCash.save
    render :text => '{"flag":"1","content":"申请成功，我们会在每月15号统一返现到银行账户"}';
  end

  def contact_us
    @block_contact_us = MallBlock.where("id = 35");
  end


  private

  def get_wash_info
    @cus_status = current_customer.card.status;
    if @cus_status == "actived"
      @today = Time.new.strftime("%Y-%m-%d");
      @days = (Time.now.strftime("%Y-%m-%d").to_date - current_customer.card.activated_date.strftime("%Y-%m-%d").to_date).to_i
      @renewal = Renewal.find(:all,:conditions=>["customer_id = ? and renewal_start <= ? and renewal_end >= ?",current_customer.id,@today,@today]);
      #在此卡有效期内本月 本应可以洗多少次(不算已洗次数)
      @total_month_count = get_total_month_count(@renewal[0].renewal_start,@today);
      #在此卡有效期内一共洗了多少次
      @used_month_count = get_used_month_count(current_customer.card.id,@renewal[0].renewal_start,@today);

      @this_month_wash = 0;
      if @total_month_count - @used_month_count > 0
        @this_month_wash = @total_month_count - @used_month_count;      
      end
      @consumption_records = current_customer.card.vendor_binding_record.consumption_records.order("created_at desc");  
    end
  end

  def get_total_month_count (start_time , end_time);
    @today_month = end_time.to_s.split("-");
    @start_month = start_time.to_s.split("-");
    @total_count = (@today_month[0].to_i*12 + @today_month[1].to_i) - (@start_month[0].to_i*12 + @start_month[1].to_i)+1;
    if @total_count > 12
      @total_count = 12
    end
    return @total_count
  end

  def get_used_month_count (card_id,start_time,end_time);
      @count = ActiveRecord::Base.connection.select("
        select 
          count(*) as count
        from consumption_records cr
        left join vendor_binding_records vbr
        on cr.vendor_binding_record_id = vbr.id
        where vbr.card_id = "+card_id.to_s+" 
        and DATE_FORMAT(cr.created_at,'%Y-%m-%d') >= '"+start_time.to_s+"' 
        and DATE_FORMAT(cr.created_at,'%Y-%m-%d') <= '"+end_time.to_s+"' 
        ");
      return @count[0]["count"]
  end
end
