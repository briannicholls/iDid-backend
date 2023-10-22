class RemoveCounterUnits < ActiveRecord::Migration[7.0]
  def change
    # remove table counter_units
    drop_table :counter_units
  end
end
