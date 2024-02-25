# frozen_string_literal: true

class ActionSerializer < ActiveModel::Serializer
  belongs_to :unit_of_measure, serializer: UnitOfMeasureSerializer
  belongs_to :user, serializer: UserSerializer

  attributes :id, :reps, :value, :unit_of_measure, :counter_id
  attribute :counter
  attribute :user_name

  attribute(:when) do
    object.created_at
  end

  def counter
    {
      name: object&.counter&.name,
      dimension: object&.counter&.dimension
      # unit: object.unit_of_measure&.name,
      # unit_abbreviation: object.unit_of_measure&.abbreviation
    }
  end

  def user_name
    object.user&.name
  end
end
