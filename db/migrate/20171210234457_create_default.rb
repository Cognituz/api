class CreateDefault < ActiveRecord::Migration[5.0]
  def change
    create_table :defaults do |t|
      t.float :hourly_price

      t.timestamps null: false
    end
  end
end
