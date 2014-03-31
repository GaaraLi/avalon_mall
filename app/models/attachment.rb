class Attachment < ActiveRecord::Base
  belongs_to :vendor

  validates :vendor_picture, presence: { message:'图片不能为空' }
  #与vendor_picture_uploader进行关联
  mount_uploader :vendor_picture, VendorPictureUploader
end
