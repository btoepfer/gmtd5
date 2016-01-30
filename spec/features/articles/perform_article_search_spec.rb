
require 'rails_helper'

# Feature: Perform Article index
#   As a registered and logged in user
#   I want to search for articels
#   So I can read and edit articles 
RSpec.feature "Perform Article Search" do

  let!(:user) {FactoryGirl.create(:user, username: "User1", email: "User1@example.de",id: 1 )}
  let!(:user2) {FactoryGirl.create(:user, username: "User2", email: "User2@example.de", id: 2 )}
  let!(:article) {FactoryGirl.create(:article, title: "NLS Parameter", content: "export NLS_LANG=AMERICAN_AMERICA.WE8ISO8859P1", user_id: 1 )}
  let!(:article2) {FactoryGirl.create(:article, title: "NLS Parameter", content: "NLS2", user_id: 2 )}
  
  before do
    login_as(user)
  end
  
  # Scenario: User can search for articles in title without wildcards
  #   Given I am a registered user
  #   When I fill in a keyword and press search
  #   Then I see a the result page
  scenario "search for title name without wildcards" do
    visit articles_path
    fill_in "article_keywords", with: "NLS Parameter"
    click_button "search"
    expect(page).to have_content "NLS Parameter"
    expect(page).to have_content "NLS_LANG"
  end
  
  # Scenario: User can search only for his own articles in title without wildcards
  #   Given I am a registered user
  #   When I fill in a keyword and press search
  #   Then I see a the result page
  scenario "search for my own articels in title name without wildcards" do
    visit articles_path
    fill_in "article_keywords", with: "NLS Parameter"
    click_button "search"
    expect(page).not_to have_content "NLS2"
  end
  
  # Scenario: User can search for articles in title with wildcards (*)
  #   Given I am a registered user
  #   When I fill in a keyword and press search
  #   Then I see a the result page
  scenario "search for title name with wildcards" do
    visit articles_path
    fill_in "article_keywords", with: "NLS*"
    click_button "search"
    expect(page).to have_content "NLS Parameter"
  end
  
  
  # Scenario: User can search for articles in title or content with wildcards (*)
  #   Given I am a registered user
  #   When I fill in a keyword and press search
  #   Then I see a the result page
  scenario "search for title or content with wildcards" do
    visit articles_path
    fill_in "article_keywords", with: "AMERICAN*"
    click_button "search"
    expect(page).to have_content "NLS Parameter"
  end
  
  
end


