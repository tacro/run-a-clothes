class Post < ApplicationRecord
  validates :name, {presence: true}
  validates :image_name, {presence: true}
  validates :price, {presence: true}
  validates :designer_id, {presence: true}
  validates :caption, {presence: true}

  def user
    return User.find_by(id: self.designer_id)
  end
end
