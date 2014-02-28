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
end
