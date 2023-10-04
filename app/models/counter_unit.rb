class CounterUnit < ApplicationRecord
  belongs_to :counter
  belongs_to :unit_of_measure
end
