class AddSystemToUnitsOfMeasure < ActiveRecord::Migration[7.0]
  def change
    add_column :units_of_measure, :system, :string, null: false, default: 'metric'
  end
end
