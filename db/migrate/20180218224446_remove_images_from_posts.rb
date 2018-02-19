class RemoveImagesFromPosts < ActiveRecord::Migration[5.1]
  def change
    remove_column :posts, :images, :json
  end
end
