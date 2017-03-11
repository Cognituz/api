class AddAttributesToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.string :school_year
      t.string :phone_number
      t.integer :age
      t.string :description
    end
  end
end
