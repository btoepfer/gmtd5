require 'rails_helper'

RSpec.feature "User can start application" do
  scenario "visit Startpage" do
    visit "/"
    expect(page).to have_content "Getting my Things Done 5.0"
  end
end
