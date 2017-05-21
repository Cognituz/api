class AddStatusToClassAppointments < ActiveRecord::Migration[5.0]
  def change
    add_column :class_appointments, :status, :string

    execute <<-SQL
      UPDATE "class_appointments"
      SET "status" = 'unconfirmed'
      WHERE "class_appointments"."status" = NULL
    SQL

    change_column_null :class_appointments, :status, false
  end
end
