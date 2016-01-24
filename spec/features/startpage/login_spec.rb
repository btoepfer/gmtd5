require 'rails_helper'
# Feature: User Login
#   As a registered user
#   I want to log in
#   So I can use the application
RSpec.feature "User Login" do
  before do
    user_en = FactoryGirl.create(:user_en)
    user_de = FactoryGirl.create(:user_de)    
    visit root_path
  end
  
  # Scenario: Login sucessfully for english user
  #   Given I am a registered user
  #   When I visit the home page
  #   Then I can login with my credentials
  scenario "Login sucessfully (en)" do
    fill_in "login_user_email", with: "user_en@example.com"
    fill_in "login_user_password", with: "please123"
    click_button "login"
    expect(page).to have_content "Signed in successfully."
  end
  
  # Scenario: Login sucessfully for german user
  #   Given I am a registered user
  #   When I visit the home page
  #   Then I can login with my credentials
  scenario "Login sucessfully (de)" do
    fill_in "login_user_email", with: "user_de@example.com"
    fill_in "login_user_password", with: "please123"
    click_button "login"
    expect(page).to have_content "Erfolgreich angemeldet."
  end
  
  # Scenario: Login failed
  #   Given I am a registered user
  #   When I visit the home page
  #   Then I get an error message when I login with wrong credentials
  scenario "Login failed" do
    fill_in "login_user_email", with: "user_en@example.com"
    fill_in "login_user_password", with: "please123x"
    click_button "login"
    expect(page).to have_content I18n.t "devise.failure.invalid"
  end
end
