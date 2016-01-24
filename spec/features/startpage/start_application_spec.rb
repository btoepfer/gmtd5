require 'rails_helper'

# Feature: Start Application
#   As a registered and logged in user
#   I want to start the application
#   So I can use it
RSpec.feature "Start Application" do
  let!(:user_en) {FactoryGirl.create(:user_en)}
  
  before do
    login_as(user_en)
  end
  
  
  # Scenario: Login sucessfully for english user
  #   Given I am a registered user
  #   When I visit the home page
  #   Then I can login with my credentials
  scenario "Login" do
    visit root_path
    expect(page).to have_content "Account"
  end
  
  
end


