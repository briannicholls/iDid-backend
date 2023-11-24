
class UnitOfMeasureSerializer < ActiveModel::Serializer
  attributes :id, :name, :names, :abbreviation, :abbreviations, :dimension

  def names
    {
      singular: object.name,
      plural: object.name.pluralize
    }
  end

  def abbreviations
    {
      singular: object.abbreviation,
      plural: object.abbreviation.pluralize
    }
  end
end
