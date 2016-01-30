
require 'rails_helper'

# Feature: Perform Article index
#   As a registered and logged in user
#   I want to search for articels
#   So I can read and edit articles 
RSpec.feature "Perform Article Search" do

  let!(:user) {FactoryGirl.create(:user, )}
  
  before do
    login_as(user)
  end
  
  # Scenario: User can search for articles
  #   Given I am a registered user
  #   When I fill in a keyword and press search
  #   Then I see a the result page
  scenario "search for keyword without wildcards" do
    visit articles_path
    fill_in "article_keywords", with: "NLS"
    click_button "search"
    expect(page).to have_content "NLS Parameter"
  end
  
  
  
end


