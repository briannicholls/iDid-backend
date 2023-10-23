# frozen_string_literal: true

class ActionSerializer < ActiveModel::Serializer
  attributes :id, :reps, :value
  attribute :counter

  attribute(:when) do
    object.created_at
  end

  def counter
    {
      name: object.counter.name,
      dimension: object.counter.dimension,
      unit: object.unit_of_measure&.abbreviation,
    }
  end

end
