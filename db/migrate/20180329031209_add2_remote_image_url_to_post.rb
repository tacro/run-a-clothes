class Add2RemoteImageUrlToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :remote_image_url, :string
  end
end
