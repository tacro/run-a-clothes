class User < ApplicationRecord
  mount_uploader :icon_image_name, AvatarUploader
  has_secure_password
  validates :name, {presence: true}
  validates :email, {presence: true , uniqueness: true}
  validates :user_group, {presence: true}
  validates :gender, {presence: true}

  has_many :following_relationships, foreign_key: "follower_id", class_name: "Relationship", dependent: :destroy
  has_many :followings, through: :following_relationships

  has_many :follower_relationships, foreign_key: "following_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :follower_relationships

  def posts
    return Post.where(designer_id: self.id).order(created_at: :desc)
  end

  def following?(other_user)
    following_relationships.find_by(following_id: other_user.id)
  end

  def follow!(other_user)
    following_relationships.create!(following_id: other_user.id)
  end

  def unfollow!(other_user)
    following_relationships.find_by(following_id: other_user.id).destroy
  end
end
