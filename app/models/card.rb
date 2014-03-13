class Card < ActiveRecord::Base
  belongs_to :customer
  belongs_to :service_combo
  has_one :vendor, :through => :vendor_binding_record
  has_one :vendor_binding_record
  has_one :transaction
  has_one :activate_code
  has_one :consumption_appointment
  before_create :generate_card_number, :default_status
  belongs_to :repaid_tactic_customer
  has_many :repaid_histories

  validates_inclusion_of :status,
    :allow_blank => true,
    :in => %w(unpaid paid actived expired)

  def avaliable_amount_for(service_id)
    service_combo.amount_for(service_id, self) - used_amount_for(service_id)
  end

  def used_amount_for(service_id)
     if vendor_binding_record.present?
       vendor_binding_record.consumption_record_oncard_for(service_id).count
     else
       0
     end
  end

  def total_amount_for(service_id)
    service_combo.total_amount_for(service_id)
  end

  def remaining_amount_for(service_id)
    self.total_amount_for(service_id) - self.used_amount_for(service_id)
  end

  def activated?
    activated_date.present? && vendor.present? && actived?
  end

  %w{paid unpaid actived expired}.each do |the_status|
    define_method "#{the_status}?"do
      the_status == status
    end
  end


  def paid(params, raw_post)
    if Rails.env.production?
      return false unless from_alipay?(params[:notify_id])
    end

    transaction = Transaction.find_by(order_no: params[:out_trade_no])

    if customer.card.status == "unpaid"
      update_attributes(status: 'paid')
    end 

    if transaction.present?
      transaction.update_attributes(transaction_attrs(params, raw_post))
    else
      customer.transactions.create(transaction_attrs(params, raw_post))
    end
  end

  #续费
  def paid_renewal(params, raw_post,card)
    if Rails.env.production?
      return false unless from_alipay?(params[:notify_id])
    end
    
    transaction = Transaction.find_by(order_no: params[:out_trade_no])
    if transaction.present?
      transaction.update_attributes(transaction_attrs(params, raw_post))
    else
      customer.transactions.create(transaction_attrs(params, raw_post))

      renewal_tran = Transaction.find_by(order_no: params[:out_trade_no])
      renewal_tran.update_attributes(status: '1');

      @expiring_date = card.expiring_date.to_date.strftime("%Y-%m-%d").to_date;
      @activated_date = card.expiring_date.to_date.strftime("%Y-%m-%d").to_date;

      @now_time = Time.now.strftime("%Y-%m-%d").to_date;
      if @now_time.to_s > @expiring_date.to_s
        @activated_date = @now_time
        @expiring_date = @now_time >> 12
      else
        @activated_date = @activated_date + 1
        @expiring_date = @expiring_date >> 12
        @expiring_date = @expiring_date + 1
      end

      Renewal.create(
        customer_id:    card.customer.id,
        transaction_id: renewal_tran.id,
        renewal_start:  @activated_date,
        renewal_end:    @expiring_date,
        price:          renewal_tran.total_fee
        );
      
      card.update_attributes(expiring_date: @expiring_date,status:"actived");
    end
  end


  def bind
    create_binding_record
    update_attributes(status: 'actived', activated_date: DateTime.now, expiring_date: 13.months.from_now.beginning_of_month, end_time: 3.months.from_now.beginning_of_month, repaid_time: 0)
  end

  private
  def generate_card_number
    self.card_number = loop do
      random_token = rand(100000..999999).to_s
      break random_token unless self.class.where(card_number: random_token).exists?
    end
  end

  def default_status
    self.status ||= 'unpaid'
  end

  def create_binding_record
    binding_attr = {vendor_id: vendor.id, card_id: self.id}
    VendorBindingRecord.create(binding_attr) unless VendorBindingRecord.exists?(binding_attr)
  end

  def from_alipay?(notify_id)
    uri = "https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{ActiveMerchant::Billing::Integrations::Alipay::ACCOUNT}&notify_id=#{notify_id}"

    html_response = nil
    open(uri) do |http|
      html_response = http.read
    end
    html_response == 'true'
  end

  def transaction_attrs(params, raw_post)
    {
      :total_fee    => params[:total_fee],
      :trade_status => params[:trade_status],
      :trade_no     => params[:trade_no],
      :order_no     => params[:out_trade_no],
      :notify_time  => params[:notify_time],
      :buyer_email  => params[:buyer_email],
      :raw_post     => raw_post,
      :card_no => params[:extra_common_param]
    }
  end
end
