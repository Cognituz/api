class AddNeighborhoodsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :neighborhoods, :text, array: true, default: []
  end
end
