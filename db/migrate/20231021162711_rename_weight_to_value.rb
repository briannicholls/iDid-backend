class RenameWeightToValue < ActiveRecord::Migration[7.0]
  def change
    rename_column :actions, :weight, :value
  end
end
