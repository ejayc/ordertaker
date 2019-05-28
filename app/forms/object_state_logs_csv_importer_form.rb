class ObjectStateLogsCsvImporterForm < BaseForm
  require 'csv'

  attribute :csv_file, File

  def save
    ObjectStateLog.transaction do
      File.foreach(csv_file.path) do |file_line|
        escaped_csv_line = escape_double_quotes_in_csv_line(file_line)
        object_id, object_type, timestamp, object_changes = CSV.parse_line(escaped_csv_line)

        ObjectStateLog.create!(
          object_id: object_id,
          object_type: object_type,
          timestamp: Time.at(timestamp.to_i),
          object_changes: object_changes
        )
      end
      true
    end
  rescue ActiveRecord::RecordInvalid => invalid
    add_to_base_errors(invalid)
  rescue CSV::MalformedCSVError
  end

  private

  def escape_double_quotes_in_csv_line(csv_line)
    csv_line.gsub('\"','""')
  end
end
