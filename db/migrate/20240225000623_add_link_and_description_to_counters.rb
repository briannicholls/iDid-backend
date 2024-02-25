class AddLinkAndDescriptionToCounters < ActiveRecord::Migration[7.0]
  def change
    add_column :counters, :link, :string
    add_column :counters, :description, :string
  end
end
