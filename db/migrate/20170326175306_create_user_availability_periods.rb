class CreateUserAvailabilityPeriods < ActiveRecord::Migration[5.0]
  def change
    create_table :user_availability_periods do |t|
      t.integer :starts_at_sfsow
      t.integer :ends_at_sfsow
      t.integer :week_day
      t.references :user, null: false
      t.timestamps
    end
  end
end
