require "rails_helper"

describe ObjectStateLogsCsvImporterForm do
  describe "#save" do
    context "when CSV file is not present" do
      let(:csv_importer_form) { described_class.new({}) }

      it { expect(csv_importer_form.save).to be false }

      it "has an error message" do
        csv_importer_form.save
        expect(csv_importer_form.full_error_messages).to eq("Csv file can't be blank")
      end
    end

    context "when CSV file is present" do
      let(:csv_importer_form) { described_class.new({ csv_file: csv_file }) }

      context "and there are invalid data in the CSV" do
        let(:csv_file) { Rack::Test::UploadedFile.new("spec/fixtures/files/csv_file_with_invalid_data.csv", "text/csv") }

        it { expect(csv_importer_form.save).to be false }

        it "doesn't save all the data" do
          expect(ObjectStateLog.count).to eq(0)
        end

        it "has an error message pointing the faulty data" do
          expected_error = "Error on row 1: Object type can't be blank\nError on row 5: Object id can't be blank\nError on row 7: Object changes can't be blank"
          csv_importer_form.save
          expect(csv_importer_form.full_error_messages).to eq(expected_error)
        end
      end

      context "and the CSV has an invalid format" do
        let(:csv_file) { Rack::Test::UploadedFile.new("spec/fixtures/files/csv_file_with_invalid_format.csv", "text/csv") }

        it { expect(csv_importer_form.save).to be false }

        it "has an error message related to malformed CSV" do
          expected_error = "Missing or stray quote in line 1"
          csv_importer_form.save
          expect(csv_importer_form.full_error_messages).to eq(expected_error)
        end
      end

      context "and there are no errors in the CSV data" do
        let(:csv_file) { Rack::Test::UploadedFile.new("spec/fixtures/files/valid_csv_file.csv", "text/csv") }

        it { expect(csv_importer_form.save).to be true }

        it "saves all the data from the CSV" do
          csv_importer_form.save
          expect(ObjectStateLog.count).to eq(7)
        end
      end
    end
  end
end
