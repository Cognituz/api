class AddCoordinatesToLocation < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :latitude, :decimal, {:precision=>10, :scale=>6}
    add_column :locations, :longitude, :decimal, {:precision=>10, :scale=>6}
    add_column :locations, :name, :string
    add_column :locations, :address, :string
    add_column :locations, :radius, :integer
    remove_column :locations, :street
    remove_column :locations, :street_number
    remove_column :locations, :notes
    remove_column :locations, :city
    remove_column :locations, :neighborhood
  end
end
