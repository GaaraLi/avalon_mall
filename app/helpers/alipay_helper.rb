require 'digest/md5'
module AlipayHelper
  def to_alipay_url(card)

    @price = card.service_combo.price.to_s;
    db = ActiveRecord::Base.connection;
    @count = db.select("
      select count(*) as count from 
      transfer_customers tc 
      left join customers c on c.id = tc.customer_id
      left join cards card on card.customer_id = c.id
      where tc.status = 0 and card.id = " + card.id.to_s);
    if @count[0]["count"] == 1
      @new_cash = db.select("select new_cus_cash from transfer_codes where id = (
        select transfer_code_id from transfer_customers 
        where customer_id = "+card.customer.id.to_s+" and status = 0)");

      @price = @price.to_i - @new_cash[0]["new_cus_cash"].to_i
    end
    redirect_to_alipay_gateway(:subject => "享车卡",
                               :body => "<卡片介绍>",
                               #:amount => card.service_combo.price.to_s,
                               :amount => @price.to_s,
                               :out_trade_no => generate_trade_no(card),
                               :notify_url => frontend_transactions_notify_url,
                               :return_url => frontend_transactions_done_url,
                               :extra_common_param => card.card_number,
                               :_input_charset => 'utf-8')
  end

  def to_alipay_renewal_url(card)
    @price = card.service_combo.price.to_s;
    redirect_to_alipay_gateway(:subject => "享车卡-续费",
                               :body => "<卡片介绍>",
                               #:amount => card.service_combo.price.to_s,
                               :amount => @price.to_s,
                               :out_trade_no => generate_trade_no(card),
                               :notify_url => frontend_transactions_notify_renewal_url,
                               :return_url => frontend_transactions_done_renewal_url,
                               :extra_common_param => card.card_number,
                               :_input_charset => 'utf-8')

  end

  def to_alipay_good( o)
    redirect_to_alipay_gateway(:subject => "享车网订单",
                               :body => "享车网订单",
                               #:amount => card.service_combo.price.to_s,
                               #:amount => o.price.to_s,
                               :amount => "0.01",
                               :out_trade_no => o.order_no,
                               :notify_url => "http://m.ixiangche.com/customers/notify_page",
                               :return_url => "http://m.ixiangche.com/customers/done_page",
                               # :notify_url => customers_notify_page_url,
                               # :return_url => customers_success_page_url,
                               :extra_common_param => o.id.to_s,
                               :_input_charset => 'utf-8')
  end


  private

  def redirect_to_alipay_gateway(options={})
    encoded_query_string = sign_params!(query_params(options)).map {|key, value| "#{key}=#{CGI.escape(value)}" }.join("&")
    "https://www.alipay.com/cooperate/gateway.do?#{encoded_query_string}"
  end

  def query_params(options)
    query_params = {
      :partner => ActiveMerchant::Billing::Integrations::Alipay::ACCOUNT,
      :out_trade_no => options[:out_trade_no],
      :total_fee => options[:amount],
      :seller_email => ActiveMerchant::Billing::Integrations::Alipay::EMAIL,
      :notify_url => options[:notify_url],
      :"_input_charset" => 'utf-8',
      :service => ActiveMerchant::Billing::Integrations::Alipay::Helper::CREATE_DIRECT_PAY_BY_USER,
      :payment_type => "1",
      :subject => options[:subject]
    }
    query_params[:body] = options[:body] if options[:body]
    query_params[:return_url] = options[:return_url] if options[:return_url]
    query_params[:extra_common_param] = options[:extra_common_param] if options[:extra_common_param]
    query_params[:_input_charset] = options[:_input_charset] if options[:_input_charset]
    Hash[query_params.sort]
  end

  def sign_params!(params)
    raw_query_string = params.map {|key, value| "#{key}=#{CGI.unescape(value)}" }.join("&")
    sign = Digest::MD5.hexdigest(raw_query_string + ActiveMerchant::Billing::Integrations::Alipay::KEY)
    params[:sign] = sign
    params[:sign_type] = 'MD5'
    params
  end

  def generate_trade_no(card)
    "#{card.card_number}-#{Time.now.to_i}"
  end
end
