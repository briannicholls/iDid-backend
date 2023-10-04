class CreateUnitsOfMeasure < ActiveRecord::Migration[7.0]
  def change
    create_table :units_of_measure do |t|
      t.string :name
      t.string :abbreviation
      t.references :counter, null: false, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
