class UnitOfMeasure < ApplicationRecord
  has_many :counter_units
  has_many :counters, through: :counter_units

  validates :name, presence: true, uniqueness: { scope: :dimension }
  validates :abbreviation, presence: true, uniqueness: { scope: :dimension }

  scope :metric, -> { where(system: %w[both metric]) }
  scope :us_standard, -> { where(system: %w[both us_standard]) }

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
