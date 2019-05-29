require "rails_helper"

describe ObjectStateLogsCsvImporterForm do
  describe "#save" do
    context "when CSV file is not present" do
      let(:csv_importer_form) { described_class.new({}) }

      it "returns false" do
        expect(csv_importer_form.save).to be false
      end

      it "has an error message" do
        csv_importer_form.save
        expect(csv_importer_form.full_error_messages).to eq("Csv file can't be blank")
      end
    end

    context "when CSV file is present" do
      context "and there are invalid data in the CSV"
      context "and the CSV has an invalid format"
      context "and there are no errors in the CSV data"
    end
  end
end
