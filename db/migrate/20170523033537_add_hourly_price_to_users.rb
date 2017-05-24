class AddHourlyPriceToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :hourly_price, :decimal
  end
end
