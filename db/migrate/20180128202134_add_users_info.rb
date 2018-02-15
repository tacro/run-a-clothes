class AddUsersInfo < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :brand_name, :string
    add_column :users, :designer_comment, :text
  end
end
