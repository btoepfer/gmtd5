require 'rails_helper'

# Feature: Home page
#   As a visitor
#   I want to visit a start page
#   So I can learn more about the website
RSpec.feature "Start page" do
  
  # Scenario: Visit the start page
  #   Given I am a visitor
  #   When I visit the home page
  #   Then I see "Getting my Things Done" and
  #   I see a login form
  scenario "visit Startpage" do
    visit root_path
    expect(page).to have_content "Getting my Things Done"
    expect(find('#navbar')).to have_button('login')
  end
end
