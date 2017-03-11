class AddPaperclipAvatarToUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :avatar
    add_attachment :users, :avatar
  end
end
