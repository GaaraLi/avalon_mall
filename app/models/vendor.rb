class Vendor < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :timeoutable
  attr_accessor :login


  has_one :address, :dependent => :destroy
  has_many :staffs
  has_many :vendor_binding_records
  has_many :cards, through: :vendor_binding_records
  has_many :supplementations
  has_many :services, :through => :supplementations
  has_many :attachments, :dependent => :destroy
  has_many :extra_consumption_records
  has_many :third_party_consumptions
  has_many :mall_order_lines
  belongs_to :mall_area

  accepts_nested_attributes_for :attachments, :allow_destroy => true
  accepts_nested_attributes_for :address, :allow_destroy => true
  accepts_nested_attributes_for :staffs, :allow_destroy => true

  validates :name, presence: { message:'商户名称不能为空' }
  validates :name, length: { maximum: 20, message:'名称最多20字。' }
  validates :description, length: { maximum: 300, message:'描述最多300字。' }
  validates :manifesto, length: { maximum: 200, message:'诚信承诺最多200字。' }
  validates :max_capacity,
    numericality: { allow_nil: true, greater_than: 0, message:'请填入一个大于零的整数。' },
    length: { maximum: 4, message:'输入范围为1～9999。' }
  validates :boss_name, :manager_name, length: { maximum: 10, message:'名称最多10字。' }
  validates :opening_hours, length: { maximum: 30, message:'最多30字。' }
  validates :boss_phone, :phone1, :phone2, :manager_phone,
    numericality: { allow_blank: true, only_integer: true, greater_than: 0, message:'请输入格式正确的电话号码' },
    length: { within: (7..20), allow_blank: true }

  validates :name, :shortname, uniqueness: { message: "用户名不能重复"}

  def self.search_card(seed)
    Card.find_by_card_number(seed) || (Customer.find_by_phone(seed).card if Customer.find_by_phone(seed)) || (Car.find_by_plate_number(seed).customer.card if Car.find_by_plate_number(seed))
  end

  def main_photo
    main_attachment = attachments.find { |attachment|
      attachment.main_pic == true
    }
    main_attachment.vendor_picture if main_attachment
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["shortname = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def display_name
    "#{name} #{address.try(:street)}".strip
  end

  def customers
    cards.map(&:customer)
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def password_required?
    if !persisted?
      false
    else
      !password.nil? || !password_confirmation.nil?
    end
  end

  def actived_customer_number
    count = 0
    self.customers.each do |customer|
      count+=1 if customer.card.actived?
    end
    count
  end

end
