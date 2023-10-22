class AddRepsToCounters < ActiveRecord::Migration[7.0]
  def change
    add_column :counters, :track_reps, :boolean, default: false
  end
end
