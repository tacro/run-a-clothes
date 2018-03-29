class RemoveRemoteImageUrlFromPosts < ActiveRecord::Migration[5.1]
  def change
    remove_column :posts, :remote_image_url ,:string
  end
end
