require 'rails_helper'

RSpec.feature "User can start application" do
  scenario "visit Startpage" do
    visit "/"
    expect(page).to have_content "Welcome to GmTD Version 5.0.x"
  end
end
