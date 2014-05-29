class SoftValidateValidator < ActiveModel::EachValidator
  def validate(record)
    record.warnings.add_on_blank(attributes, options)
  end
end
