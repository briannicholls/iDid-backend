class UnitOfMeasure < ApplicationRecord
  has_many :counter_units
  has_many :counters, through: :counter_units

  validates :name, :abbreviation, presence: true, uniqueness: true

  scope :metric, -> { where(system: 'metric') }
  scope :us_standard, -> { where(system: 'us_standard') }

  def self.common_unit(dimension)
    case dimension
    when 'weight'
      'kg'
    when 'time'
      'sec'
    when 'distance'
      'm'
    end
  end
end
