class CreateObjectStateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :object_state_logs do |t|
      t.integer :object_id, null: false
      t.string :object_type, null: false
      t.timestamp :timestamp, null: false
      t.json :object_changes, null: false
      t.timestamps
    end

    add_index :object_state_logs, [:object_id, :object_type, :timestamp], name: "object_state_logs_uniq_id_type_timestamp", unique: true
  end
end
