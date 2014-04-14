class ExtraConsumptionRecord < ActiveRecord::Base
  belongs_to :vendor
  belongs_to :customer
  belongs_to :extra_service_detail
  has_one :repaid_history
  

  validates :price, presence: { message:'金额不能为空' }
  validates :price, numericality: { message: '请输入有效的数字' }
  validates :price, length: { maximum: 10, message:'最多输入10位有效数字' }

  def record_content
    if self.extra_service_detail
    	if self.extra_service_detail.content == '其他'
    		self.extra_service_detail.extra_service_type.content + '-' + self.extra_service_detail.content
    	else
    		self.extra_service_detail.content
    	end
    end
  end
end