class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.string :street, null: false
      t.string :street_number, null: false
      t.string :notes
      t.string :city, null: false
      t.string :neighborhood
      t.references :user, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
