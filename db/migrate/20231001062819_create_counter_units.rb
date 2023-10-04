class CreateCounterUnits < ActiveRecord::Migration[7.0]
  def change
    create_table :counter_units do |t|
      t.integer :counter_id, null: false
      t.integer :unit_of_measure_id, null: false

      t.timestamps
    end

    add_index :counter_units, :counter_id
    add_index :counter_units, :unit_of_measure_id
    add_index :counter_units, [:counter_id, :unit_of_measure_id], unique: true

    add_foreign_key :counter_units, :counters
    add_foreign_key :counter_units, :units_of_measure
  end
end
