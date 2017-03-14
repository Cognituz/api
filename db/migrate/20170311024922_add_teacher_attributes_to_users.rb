class AddTeacherAttributesToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.boolean :teaches_online
      t.boolean :teaches_at_own_place
      t.boolean :teaches_at_students_place
      t.boolean :teaches_at_public_place
    end
  end
end
