require "rails_helper"

feature "Object state logs search form" do
  scenario "when there's no record yet" do
    visit object_state_logs_path
    within ".search-card" do
      expect(page).to have_text "There are no records for searching yet. Please upload a CSV file first."
    end
  end

  context "when there's an existing record" do
    before do
      create_list(:object_state_log, 2, :order)
      create_list(:object_state_log, 2, :invoice)
      create_list(:object_state_log, 2, :product)
      create_list(:object_state_log, 2, :purchase_order)
    end

    scenario "search area is visible" do
      visit object_state_logs_path
      within ".search-card" do
        expect(page).to have_text "Total number of records: #{ObjectStateLog.count}"
        expect(page).to have_button "Search"
      end
    end

    scenario "search result parameter does not match any data" do
      visit object_state_logs_path

      within ".search-card" do
        select ObjectStateLog.last.object_type, from: "object_type"
        fill_in "object_id", with: 1241251241212
        fill_in "timestamp", with: Time.zone.now.to_i
        click_button "Search"

        within ".search-result" do
          expect(page).to have_text "Search Result"
          expect(page).to have_text "No results found"
        end
      end
    end

    scenario "search result parameter returns a result" do
      search_object = ObjectStateLog.last
      visit object_state_logs_path

      within ".search-card" do
        select search_object.object_type, from: "object_type"
        fill_in "object_id", with: search_object.object_id
        fill_in "timestamp", with: search_object.timestamp.to_i
        click_button "Search"

        within ".search-result" do
          expect(page).to have_text "Search Result"
          expect(page).to have_text search_object.object_id
          expect(page).to have_text search_object.object_type
          expect(page).to have_text search_object.timestamp.to_i
          expect(page).to have_text search_object.object_changes
        end
      end
    end

    scenario "search paramters are cleared" do
      visit object_state_logs_path(object_type: "Invoice", object_id: 1, timestamp: 4)

      within ".search-card" do
        click_link "Reset"
        expect(page).not_to have_text "Search Result"
        expect(find_field("object_id").value).to be_blank
        expect(find_field("timestamp").value).to be_blank
      end
    end
  end
end
