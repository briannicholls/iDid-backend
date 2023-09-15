class ActionSerializer < ActiveModel::Serializer
  attributes :id, :reps
  attribute :counter

  attribute(:when) {
    object.created_at.in_time_zone(object.user.time_zone).strftime("%D at %l:%M %p")
  }

  def counter
    {
      name: object.counter.name,
      kind: object.counter.kind,
      unit: object.counter.measurement_unit
    }
  end

  attribute :weight, if: :is_weighted?
  # attribute :weight_unit, if: :is_weighted?

  # attribute :time_duration, if: :is_timed?
  # attribute :time_unit, if: :is_timed?

  def is_timed?
    object.counter.kind == 'timed' ? true : false
  end

  def is_weighted?
    object.counter.kind == 'weighted' ? true : false
  end

end
