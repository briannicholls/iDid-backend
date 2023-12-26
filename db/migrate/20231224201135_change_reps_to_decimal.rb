class ChangeRepsToDecimal < ActiveRecord::Migration[7.0]
  def change
    change_column :actions, :reps, :decimal
  end
end
