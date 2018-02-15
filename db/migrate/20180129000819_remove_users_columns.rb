class RemoveUsersColumns < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :designer_comment, :text
    remove_column :users, :designer_name, :string
  end
end
