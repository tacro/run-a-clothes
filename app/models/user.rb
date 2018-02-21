class User < ApplicationRecord
  mount_uploader :icon_image_name, AvatarUploader
  has_secure_password
  validates :name, {presence: true}
  validates :email, {presence: true , uniqueness: true}
  validates :user_group, {presence: true}
  validates :gender, {presence: true}

  def posts
    return Post.where(designer_id: self.id).order(created_at: :desc)
  end
end
