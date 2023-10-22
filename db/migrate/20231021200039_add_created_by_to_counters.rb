class AddCreatedByToCounters < ActiveRecord::Migration[7.0]
  def change
    add_column :counters, :created_by, :integer
  end
end
