class AddUnitOfMeasureIdToActions < ActiveRecord::Migration[7.0]
  def change
    add_reference :actions, :unit_of_measure, null: true, foreign_key: true
  end
end
