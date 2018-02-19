class Add2ImagesToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :images, :string
  end
end
