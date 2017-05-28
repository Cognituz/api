class CreateStudySubjects < ActiveRecord::Migration[5.0]
  def change
    create_table :study_subjects do |t|
      t.string :level
      t.string :name

      t.timestamps
    end
  end
end
