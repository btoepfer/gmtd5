require 'rails_helper'

# Feature: Show Article index Page
#   As a registered and logged in user
#   I want to navigate to the article index page
#   So I can search and edit articles it
RSpec.feature "Show Article index" do

  let!(:user) {FactoryGirl.create(:user, )}
  
  # Scenario: index page exists and has search form
  #   Given I am a registered user
  #   When I visit the article index page
  #   Then I see a search form
  scenario "logged in" do
    login_as(user)
    visit articles_path
    expect(page).to have_field('article_keywords', :type => 'search')
  end
  
  # Scenario: unregistered user cannot access search form
  #   Given I am a visitor
  #   When I visit the article index page
  #   Then I see a get a message that I have to sign in first
  scenario "Not logged in" do
    visit articles_path
    expect(page).to have_content I18n.t "devise.failure.unauthenticated"
  end
  
  
end


