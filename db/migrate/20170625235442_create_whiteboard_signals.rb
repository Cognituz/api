class CreateWhiteboardSignals < ActiveRecord::Migration[5.0]
  def change
    create_table :whiteboard_signals do |t|
      t.json :data, null: false
      t.datetime :date, null: false
      t.references :class_appointment, foreign_key: true, null: false

      t.timestamps
    end
  end
end
