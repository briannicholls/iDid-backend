# frozen_string_literal: true

class ActionSerializer < ActiveModel::Serializer
  attributes :id, :reps, :value
  attribute :counter

  attribute(:when) do
    object.created_at.in_time_zone(object.user.time_zone).strftime('%D at %l:%M %p')
  end

  def counter
    {
      name: object.counter.name,
      kind: object.counter.kind,
      # unit: object.counter.measurement_unit
    }
  end

  # def timed?
  #   object.counter.kind == 'timed'
  # end

  # def weighted?
  #   object.counter.kind == 'weighted'
  # end

end
