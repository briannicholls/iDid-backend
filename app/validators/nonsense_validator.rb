class NonsenseValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.present? && nonsensical?(value)

    record.errors.add(attribute, 'must contain only letters and spaces')
  end

  private

  def nonsensical?(value)
    value !~ /\A[a-zA-Z\s]+\z/
  end
end
