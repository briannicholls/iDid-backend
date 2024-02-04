# frozen_string_literal: true

class Counter < ApplicationRecord
  has_many :actions
  has_many :counter_units
  has_many :units_of_measure, through: :counter_units

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 2, maximum: 30 },
                   obscenity: true, nonsense: true
  validates :dimension, presence: true, inclusion: { in: %w[default weight time distance] }
  # track_reps should be true if dimension is default
  validates :track_reps, inclusion: { in: [true] }, if: -> { dimension == 'default' }

  before_save :titleize_name

  scope :default, -> { where(dimension: 'default') }
  scope :weighted?, -> { where(dimension: 'weight') }
  scope :timed?, -> { where(dimension: 'time') }
  scope :reps?, -> { where(track_reps: true) }

  def metered?
    dimension != 'default'
  end

  def titleize_name
    self.name = name.titleize
    # ascertain singular and plural names
    self.name_singular = name.singularize
    self.name_plural = name.pluralize
  end

  # returns leaders since datetime
  def self.leaders(datetime)
    Counter.all.map do |counter|
      counter.leader(datetime)
    end.filter(&:present?)
  end

  def leader(datetime)
    # Determine the dimension of the counter
    dimension = self.dimension

    # Start building the query
    actions_in_range = actions.since(datetime)
                              .left_joins(:unit_of_measure)
                              .group(:user_id)

    # Determine the select statement based on dimension and track_reps
    select_statement = 'actions.user_id, '
    select_statement += 'SUM(actions.reps) as total_reps, ' if track_reps

    conversion_column = case dimension
                        when 'time'
                          'units_of_measure.conversion_factor_to_seconds'
                        when 'weight'
                          'units_of_measure.conversion_factor_to_kilograms'
                        when 'distance'
                          'units_of_measure.conversion_factor_to_kilometers'
                        else
                          '1' # No conversion for default or unknown dimensions
                        end

    if dimension != 'default'
      select_statement += "SUM(actions.value * COALESCE(#{conversion_column}, 1)) as total_converted_value, "
    end

    # Remove the trailing comma and space
    select_statement.chomp!(', ')

    actions_in_range = actions_in_range.select(select_statement)

    # Build the order clause conditionally based on track_reps and dimension
    order_statements = []
    order_statements << 'SUM(actions.reps) DESC' if track_reps
    order_statements << "SUM(actions.value * COALESCE(#{conversion_column}, 1)) DESC" if dimension != 'default'

    # Use Arel.sql to safely include raw SQL
    order_clause = Arel.sql(order_statements.join(', '))

    # Get the leader based on the total value
    leader_record = actions_in_range.order(order_clause).first
    return {} unless leader_record

    leader = User.find_by(id: leader_record.user_id)
    {
      counter_id: id,
      counter_name: name,
      name: leader&.name,
      total_reps: leader_record.try(:total_reps),
      total_converted_value: leader_record.try(:total_converted_value)&.round(2),
      user_id: leader&.id,
      dimension:,
      units: UnitOfMeasure.common_unit(dimension),
      track_reps:
    }
  end

  private

  def validate_name_for_nonsense
    return if name =~ /\A[a-zA-Z\s()-]+\z/

    errors.add(:name, 'must not contain illegal characters')
  end
end
