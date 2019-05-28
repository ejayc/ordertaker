class BaseForm
  include ActiveModel::Validations
  include Virtus.model

  def full_error_messages
    errors.full_messages.reject(&:blank?).to_sentence
  end

  def add_to_base_errors(invalid)
    error_message = invalid.record.errors.full_messages.to_sentence
    invalid.record.errors.clear
    errors.add(:base, error_message)
    false
  end
end
