require 'rails_helper'

# Feature: Show Note index Page
#   As a registered and logged in user
#   I want to navigate to the note index page
#   So I can search and edit notes it
RSpec.feature "Show Note index" do

  let!(:user) {FactoryGirl.create(:user, )}
  
  # Scenario: index page exists and has search form
  #   Given I am a registered user
  #   When I visit the note index page
  #   Then I see a search form
  scenario "logged in" do
    login_as(user)
    visit notes_path
    expect(page).to have_field('note_keywords', :type => 'search')
  end
  
  # Scenario: unregistered user cannot access search form
  #   Given I am a visitor
  #   When I visit the note index page
  #   Then I see a get a message that I have to sign in first
  scenario "Not logged in" do
    visit notes_path
    expect(page).to have_content I18n.t "devise.failure.unauthenticated"
  end
  
  
end


