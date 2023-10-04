class AddDimensionToUnitsOfMeasure < ActiveRecord::Migration[7.0]
  def change
    add_column :units_of_measure, :dimension, :string, null: false
  end
end
