class CreateClassAppointments < ActiveRecord::Migration[5.0]
  def change
    create_table :class_appointments do |t|
      t.references :teacher,
        null: false,
        index: true,
        foreign_key: { to_table: :users }

      t.references :student,
        null: false,
        index: true,
        foreign_key: { to_table: :users }

      t.datetime :starts_at, null: false, index: true
      t.datetime :ends_at, null: false, index: true
      t.integer :kind, null: false
      t.string :place_desc
      t.text :desc
      t.timestamps null: false
    end

    create_table :class_appointment_attachments do |t|
      t.references :appointment, null: :false, index: true,
        foreign_key: { to_table: :class_appointments }
      t.attachment :content, null: false
    end
  end
end
