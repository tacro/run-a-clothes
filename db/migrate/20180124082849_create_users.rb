class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.string :icon_image_name
      t.string :bag
      t.string :address
      t.integer :user_group
      t.string :designer_name
      t.text :designer_profile

      t.timestamps
    end
  end
end
