class ObjectStateLog < ApplicationRecord
  # If we don't provide a custom validation message for object_id,
  # it'll return a vague "Object can't be blank" error message
  validates :object_id, presence: { message: "id can't be blank" }
  validates :object_type,
            :timestamp,
            :object_changes,
            presence: true

  validates :object_id,
            uniqueness: {
              scope: [:object_type, :timestamp],
              message: "with the same id, type and timestamp already exists"
            }

  def self.unique_object_types
    distinct(:object_type).order(:object_type).pluck(:object_type)
  end
end
