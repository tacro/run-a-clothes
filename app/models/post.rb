class Post < ApplicationRecord
  mount_uploaders :image_name, ItemImageUploader
  serialize :image_name, JSON
  # crop用の仮想attribute
  attr_accessor :image_x
  attr_accessor :image_y
  attr_accessor :image_w
  attr_accessor :image_h

  #mount_uploader :image_name, ItemImageUploader
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
