class RemoveCounterIdFromUnitsOfMeasure < ActiveRecord::Migration[7.0]
  def change
    remove_column :units_of_measure, :counter_id, :integer
  end
end
