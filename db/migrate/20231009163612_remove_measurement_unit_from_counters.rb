class RemoveMeasurementUnitFromCounters < ActiveRecord::Migration[7.0]
  def change
    remove_column :counters, :measurement_unit, :string
  end
end
