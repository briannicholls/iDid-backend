class RenameKindToDimension < ActiveRecord::Migration[7.0]
  def change
    rename_column :counters, :kind, :dimension
  end
end
