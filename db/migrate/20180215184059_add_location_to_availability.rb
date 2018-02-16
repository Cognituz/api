class AddLocationToAvailability < ActiveRecord::Migration[5.0]
  def change
    add_reference :user_availability_periods, :location, index: true
  end
end
