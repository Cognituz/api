class AddFieldsForCarrierwaveBackgrounderToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :avatar_tmp, :string
    add_column :users, :avatar_processing, :string
  end
end
