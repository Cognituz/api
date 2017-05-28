class CreateUserTaughtSubjectLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :study_subject_links do |t|
      t.references :study_subject, foreign_key: true
      t.references :user, foreign_key: true
      t.references :class_appointment, foreign_key: true
      t.timestamps null: false
    end
  end
end
