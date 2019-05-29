class ObjectStateLogsController < ApplicationController
  def index
    @object_types = ObjectStateLog.unique_object_types
    @object_state_logs_count = ObjectStateLog.count

    if search_params_present?
      @search_result = ObjectStateLog.find_by(
        object_id: params[:object_id],
        object_type: params[:object_type],
        timestamp: Time.at(params[:timestamp].to_i))
    end
  end

  def import
    csv_importer_form = ObjectStateLogsCsvImporterForm.new(object_state_logs_param)

    if csv_importer_form.save
      flash[:success] = "Your data have been imported!"
    else
      flash[:error] = csv_importer_form.full_error_messages
    end

    redirect_to object_state_logs_path
  end

  private

  def search_params_present?
    [params[:object_id], params[:object_type], params[:timestamp]].all?(&:present?)
  end

  helper_method :search_params_present?

  def object_state_logs_param
    params.permit(:csv_file)
  end
end
