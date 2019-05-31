class ObjectStateAggregator
  def self.generate_aggregated_state(object_id:, object_type:, timestamp:)
    new(object_id, object_type, timestamp).aggregate_changes
  end

  def initialize(object_id, object_type, timestamp)
    @object_id = object_id
    @object_type = object_type
    @timestamp = timestamp
  end

  def aggregate_changes
    retrieve_object_changes_since_timestamp
    aggregate_object_changes.to_json
  end

  private

  def aggregate_object_changes
    @object_changes.each_with_object({}) do |changes_json, aggregate|
      aggregate.deep_merge!(JSON.parse(changes_json))
    end
  end

  def retrieve_object_changes_since_timestamp
    @object_changes = ObjectStateLog
      .where(object_id: @object_id, object_type: @object_type)
      .where("timestamp <= ?", Time.zone.at(@timestamp))
      .pluck(:object_changes)
  end
end
