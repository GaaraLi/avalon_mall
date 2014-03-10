# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
IxcMall::Application.initialize!
#支付宝配置
ActiveMerchant::Billing::Integrations::Alipay::KEY = "klmcnoij4llspar02lofquee3jprc9vy"
ActiveMerchant::Billing::Integrations::Alipay::ACCOUNT = "2088011612197064"
ActiveMerchant::Billing::Integrations::Alipay::EMAIL = "xiancheshang@gmail.com"
RbConfig.gem "activemerchant", :lib => "active_merchant"
RbConfig.gem "activemerchant_patch_for_china", :lib => false
require 'active_merchant'
require 'active_merchant/billing/integrations/action_view_helper'
ActionView::Base.send(:include, ActiveMerchant::Billing::Integrations::ActionViewHelper)
