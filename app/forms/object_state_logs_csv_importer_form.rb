class ObjectStateLogsCsvImporterForm < BaseForm
  require 'csv'

  attribute :csv_file, File, default: nil
  attribute :object_state_logs_from_csv, Array[ObjectStateLog], default: []

  validates_presence_of :csv_file

  def save
    return false unless valid?

    initialize_object_state_logs_from_csv
    validate_all_object_state_logs!
    save_all_object_state_logs!
  rescue ActiveRecord::RecordInvalid => invalid
    add_to_base_errors(invalid)
  rescue CSV::MalformedCSVError => csv_error
    errors.add(:base, csv_error.message)
    false
  end

  private

  def save_all_object_state_logs!
    ObjectStateLog.transaction do
      object_state_logs_from_csv.each(&:save!)
    end
  end

  def validate_all_object_state_logs!
    error_messages = collect_error_messages

    if error_messages.any?
      errors.add(:base, error_messages.join("\n"))
      raise ActiveRecord::RecordInvalid.new(self)
    end
  end

  def collect_error_messages
    object_state_logs_from_csv.map.with_index(1) do |object_state_log_from_csv, row_number|
      unless object_state_log_from_csv.valid?
        "Error on row #{row_number}: #{object_state_log_from_csv.errors.full_messages.to_sentence}"
      end
    end
  end

  def initialize_object_state_logs_from_csv
    File.foreach(csv_file.path) do |file_line|
      escaped_csv_line = escape_double_quotes_in_csv_line(file_line)
      object_id, object_type, timestamp, object_changes = CSV.parse_line(escaped_csv_line)

      object_state_logs_from_csv << ObjectStateLog.new(
        object_id: object_id,
        object_type: object_type,
        timestamp: Time.at(timestamp.to_i),
        object_changes: object_changes
      )
    end
  end

  def escape_double_quotes_in_csv_line(csv_line)
    csv_line.gsub('\"','""')
  end
end
