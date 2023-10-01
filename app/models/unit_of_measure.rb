class UnitOfMeasure < ApplicationRecord
  has_many :counter_units
  has_many :counters, through: :counter_units

  validates :name, :abbreviation, presence: true, uniqueness: true
end
