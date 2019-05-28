class ObjectStateLogsController < ApplicationController
  def index; end

  def import
    csv_importer_form = ObjectStateLogsCsvImporterForm.new(object_state_logs_param)

    if csv_importer_form.save
    else
    end
  end

  def object_state_logs_param
    params.permit(:csv_file)
  end
end
