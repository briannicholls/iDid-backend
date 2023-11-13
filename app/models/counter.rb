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
    # filter actions in this time range
    actions_in_range = actions.since(datetime)

    # get unique users having actions for this counter
    unique_users = actions_in_range.pluck(:user_id).uniq

    leader = nil

    # for each unique user having performed actions in this time range for this counter
    reps = unique_users.inject(0) do |memo, user_id|
      # get those actions
      acs = actions_in_range.where('user_id = ?', user_id)
      # sum the reps
      reps = acs.sum(:reps)

      if reps > memo
        leader = User.find_by(id: user_id)
        reps
      else
        memo
      end
    end
    if leader
      { counter_name: name, name: leader.name, reps:, user_id: leader.id }
    else
      {}
    end
  end

  # returns leaders since datetime
  def self.leaders(datetime)
    Counter.all.map do |counter|
      counter.leader(datetime)
    end
  end
end
