class CreateUserTaughtSubjects < ActiveRecord::Migration[5.0]
  def change
    create_table :user_taught_subjects do |t|
      t.string :name, null: false
      t.string :level, null: false
      t.references :user, null: false
      t.timestamps null: false
    end
  end
end
