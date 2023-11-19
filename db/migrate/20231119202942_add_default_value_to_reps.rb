class AddDefaultValueToReps < ActiveRecord::Migration[7.0]
  def change
    change_column_default :actions, :reps, 0
  end
end
