class Post < ApplicationRecord
  mount_base64_uploader :image_name, ItemImageUploader
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
  has_and_belongs_to_many :tags

  after_create do
    post = Post.find_by(id: self.id)
    hashtags = self.detail.scan(/#\w+/)
    hashtags.uniq.map do |hashtag|
      tag = Tag.find_or_create_by(name: hashtag.downcase.delete('#'))
      post.tags << tag
    end
  end

  before_update do
    post = Post.find_by(id: self.id)
    post.tags.clear #delete all and add again
    hashtags = self.detail.scan(/#\w+/)
    hashtags.uniq.map do |hashtag|
      tag = Tag.find_or_create_by(name: hashtag.downcase.delete('#'))
      post.tags << tag
    end
  end

  def user
    return User.find_by(id: self.designer_id)
  end
end
