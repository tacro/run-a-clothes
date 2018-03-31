class ChangeUsersColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :user_group, :integer
    add_column :users, :avatar, :string
    add_column :users, :gender, :integer
    add_column :users, :profile, :string
  end
end
