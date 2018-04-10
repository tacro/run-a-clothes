class Post < ApplicationRecord
  # mount_base64_uploader :image_name, ItemImageUploader
  # compromised uploading serial images to use base64...
  # mount_uploaders :image_name, ItemImageUploader
  # serialize :image_name, JSON
  attr_accessor :remote_image_url
  validates :image_name, {presence: true}
  validates :designer_id, {presence: true}
  # not deleting these 3 vars. They might be necessary when service has grown...
  # validates :name, {presence: true}
  # validates :price, {presence: true}
  # validates :caption, {presence: true}

  def user
    return User.find_by(id: self.designer_id)
  end
end
