class ObjectStateLogsController < ApplicationController
  def index; end

  def import
    csv_importer_form = ObjectStateLogsCsvImporterForm.new(object_state_logs_param)

    if csv_importer_form.save
      flash[:notice] = "Your data has been imported!"
    else
      flash[:alert] = csv_importer_form.full_error_messages
    end

    redirect_to object_state_logs_path
  end

  def object_state_logs_param
    params.permit(:csv_file)
  end
end
