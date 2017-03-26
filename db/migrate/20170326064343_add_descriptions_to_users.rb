class AddDescriptionsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :short_desc, :string
    add_column :users, :long_desc, :text
  end
end
