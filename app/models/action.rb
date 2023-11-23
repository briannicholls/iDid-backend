class Action < ApplicationRecord
  belongs_to :counter
  belongs_to :user, optional: true
  belongs_to :routine, optional: true
  belongs_to :unit_of_measure, optional: true

  # if value is present and not zero, must have unit of measure ID, and vice versa
  validate :value_and_unit_of_measure_consistency
  # validates that actions measuring metered counters have units of measure
  validates :unit_of_measure_id, presence: true, if: :metered?

  scope :today, -> { Action.where('created_at >= ?', 24.hours.ago) }
  scope :week, -> { Action.where('created_at >= ?', 1.week.ago) }
  scope :month, -> { Action.where('created_at >= ?', 1.month.ago) }

  scope :total_reps, -> { sum(:reps) }
  scope :recent, -> { Action.order('created_at DESC limit 10') }

  def metered?
    counter.metered?
  end

  def self.since(datetime)
    Action.where('actions.created_at >= ? ', datetime)
  end

  def since(datetime)
    Action.where('user_id = ? AND created_at >= ? ', user.id, datetime)
  end

  private

  def value_and_unit_of_measure_consistency
    if value.present? && value != 0 && unit_of_measure_id.blank?
      errors.add(:unit_of_measure_id, 'must be present if value is non-zero')
    elsif unit_of_measure_id.present? && (value.blank? || value.zero?)
      errors.add(:value, 'must be non-zero if unit of measure ID is present')
    end
  end
end
