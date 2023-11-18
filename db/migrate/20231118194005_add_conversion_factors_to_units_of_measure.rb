class AddConversionFactorsToUnitsOfMeasure < ActiveRecord::Migration[7.0]
  def change
    add_column :units_of_measure, :conversion_factor_to_seconds, :float
    add_column :units_of_measure, :conversion_factor_to_kilograms, :float
    add_column :units_of_measure, :conversion_factor_to_kilometers, :float
  end
end
