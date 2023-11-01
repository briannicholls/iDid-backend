class AddSingularAndPluralNamesToCounters < ActiveRecord::Migration[7.0]
  def change
    add_column :counters, :name_singular, :string
    add_column :counters, :name_plural, :string
  end
end
