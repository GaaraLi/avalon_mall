class MallOrder < ActiveRecord::Base
  belongs_to :vendor
  belongs_to :customer
  has_many   :mall_order_lines

  def paid( params, request_post)
    if Rails.env.production?
      return false unless from_alipay?(params[:notify_id])
    end
    if mall_order.status == 0
      update_attributes(status: 2)
    end 
  end


  private
    def from_alipay?(notify_id)
    uri = "https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{ActiveMerchant::Billing::Integrations::Alipay::ACCOUNT}&notify_id=#{notify_id}"

    html_response = nil
    open(uri) do |http|
      html_response = http.read
    end
    html_response == 'true'
  end

end
