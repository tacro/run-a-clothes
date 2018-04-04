class AddAcceptedToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :accepted, :boolean
  end
end
