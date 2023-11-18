# frozen_string_literal: true

class Counter < ApplicationRecord
  has_many :actions
  has_many :counter_units
  has_many :units_of_measure, through: :counter_units

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 2, maximum: 30 }
  validates_inclusion_of :dimension, in: %w[default weight time], if: -> { dimension.present? }

  before_save :titleize_name

  def metered?
    dimension != 'default'
  end

  def titleize_name
    self.name = name.titleize
    # ascertain singular and plural names
    self.name_singular = name.singularize
    self.name_plural = name.pluralize
  end

  # returns user with most reps for this counter since datetime
  def leader(datetime)
    # Filter actions in this time range and sum reps for each user
    user_reps = actions.since(datetime)
                       .group(:user_id)
                       .select(:user_id, 'SUM(reps) as total_reps')
                       .order('total_reps DESC')
                       .first

    return {} unless user_reps

    leader = User.find_by(id: user_reps.user_id)
    { counter_name: name, name: leader.name, reps: user_reps.total_reps, user_id: leader.id }
  end

  # returns leaders since datetime
  def self.leaders(datetime)
    Counter.all.map do |counter|
      counter.leader(datetime)
    end
  end
end

# def leader_with_time(datetime)
#   # Assuming `value` in `actions` represents the time in different units
#   # and `unit_of_measure_id` links to a table with conversion factors to seconds

#   actions_in_range = actions.since(datetime)
#                             .joins(:unit_of_measure)
#                             .select('actions.user_id', 'SUM(actions.value * units_of_measure.conversion_factor_to_seconds) as total_time')
#                             .group(:user_id)
#                             .order('total_time DESC')
#                             .first

#   return {} unless actions_in_range

#   leader = User.find_by(id: actions_in_range.user_id)
#   { counter_name: name, name: leader.name, total_time: actions_in_range.total_time, user_id: leader.id }
# end
