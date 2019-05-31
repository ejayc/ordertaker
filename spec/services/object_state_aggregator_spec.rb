require "rails_helper"

describe ObjectStateAggregator do
  let(:five_days_ago) { Time.zone.at((Time.zone.now - 5.days).to_i) }
  let(:ten_days_ago) { Time.zone.at((Time.zone.now - 10.days).to_i) }

  describe ".generate_aggregated_state" do
    before do
      create_list(:object_state_log, 3, :order)
      create_list(:object_state_log, 3, :invoice)
      create_list(:object_state_log, 3, :product)

      create(:object_state_log,
             object_type: "Order",
             object_id: 500,
             object_changes: "{\"customer_name\":\"Jack\",\"customer_address\":\"Trade St.\",\"status\":\"unpaid\"}",
             timestamp: ten_days_ago)

      create(:object_state_log,
             object_type: "Order",
             object_id: 500,
             object_changes: "{\"status\":\"paid\",\"ship_date\":\"2017-01-18\",\"shipping_provider\":\"DHL\"}",
             timestamp: five_days_ago)

      create(:object_state_log,
             object_type: "Order",
             object_id: 500,
             object_changes: "{\"status\":\"returned\"}",
             timestamp: (Time.zone.now - 3.hours))

    end

    context "when there's single object change since the given timestamp" do
      let(:object_state_log) { ObjectStateLog.first }

      it "returns the object state" do
        expect(
          described_class.generate_aggregated_state(
            object_id: object_state_log.object_id,
            object_type: object_state_log.object_type,
            timestamp: object_state_log.timestamp.to_i)).to eq(object_state_log.object_changes)
      end
    end

    context "when there are multiple object changes since the given timestamp" do
      context "and the given timestamp is 10 days ago" do
        it "returns the state of the object 10 days ago" do
          expect(described_class.generate_aggregated_state(object_id: 500, object_type: "Order", timestamp: ten_days_ago.to_i))
            .to eq("{\"customer_name\":\"Jack\",\"customer_address\":\"Trade St.\",\"status\":\"unpaid\"}")
        end
      end

      context "and the given timestamp is 4 hours ago" do
        it "returns the state of the object 4 hours ago" do
          expect(described_class.generate_aggregated_state(object_id: 500, object_type: "Order", timestamp: (Time.zone.now - 4.hours).to_i))
            .to eq("{\"customer_name\":\"Jack\",\"customer_address\":\"Trade St.\",\"status\":\"paid\",\"ship_date\":\"2017-01-18\",\"shipping_provider\":\"DHL\"}")
        end
      end

      context "and the given timestamp is exactly 5 days ago" do
        it "returns the state of the object 5 days ago" do
          expect(described_class.generate_aggregated_state(object_id: 500, object_type: "Order", timestamp: five_days_ago.to_i))
            .to eq("{\"customer_name\":\"Jack\",\"customer_address\":\"Trade St.\",\"status\":\"paid\",\"ship_date\":\"2017-01-18\",\"shipping_provider\":\"DHL\"}")
        end
      end

      context "and the given timestamp is now" do
        it "returns the state of the object since now" do
          expect(described_class.generate_aggregated_state(object_id: 500, object_type: "Order", timestamp: Time.zone.now.to_i))
            .to eq("{\"customer_name\":\"Jack\",\"customer_address\":\"Trade St.\",\"status\":\"returned\",\"ship_date\":\"2017-01-18\",\"shipping_provider\":\"DHL\"}")
        end
      end

      context "and the given timestamp is 11 days ago" do
        it "returns an empty state of the object" do
          expect(described_class.generate_aggregated_state(object_id: 500, object_type: "Order", timestamp: (Time.zone.now - 11.days).to_i))
            .to eq("{}")
        end
      end

      context "and the given timestamp is a future date" do
        it "returns the state of the object since today" do
          expect(described_class.generate_aggregated_state(object_id: 500, object_type: "Order", timestamp: (Time.zone.now + 1.day).to_i))
            .to eq("{\"customer_name\":\"Jack\",\"customer_address\":\"Trade St.\",\"status\":\"returned\",\"ship_date\":\"2017-01-18\",\"shipping_provider\":\"DHL\"}")
        end
      end
    end
  end
end
