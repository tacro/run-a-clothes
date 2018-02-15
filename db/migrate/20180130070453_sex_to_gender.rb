class SexToGender < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :sex, :integer
    add_column :users, :gender, :integer
  end
end
