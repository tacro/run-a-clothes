class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :name
      t.string :image_name
      t.integer :price
      t.text :caption
      t.text :detail
      t.integer :designer_id

      t.timestamps
    end
  end
end
