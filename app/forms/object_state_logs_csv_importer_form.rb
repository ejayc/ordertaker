class ObjectStateLogsCsvImporterForm < BaseForm
  require 'csv'

  attribute :csv_file, File

  def save
    ObjectStateLog.transaction do
      CSV.parse(csv_file.read.gsub('\"','""')) do |row|
        object_id, object_type, timestamp, object_changes = row

        ObjectStateLog.create!(
          object_id: object_id,
          object_type: object_type,
          timestamp: Time.at(timestamp.to_i),
          object_changes: object_changes
        )
      end
    end
  rescue ActiveRecord::RecordInvalid
  rescue CSV::MalformedCSVError
  end
end
