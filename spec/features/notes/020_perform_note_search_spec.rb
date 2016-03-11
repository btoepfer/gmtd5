
require 'rails_helper'

# Feature: Perform Note index
#   As a registered and logged in user
#   I want to search for articels
#   So I can read and edit notes 
RSpec.feature "Perform Note Search" do

  let!(:user) {FactoryGirl.create(:user, username: "User1", email: "User1@example.de",id: 1 )}
  let!(:user2) {FactoryGirl.create(:user, username: "User2", email: "User2@example.de", id: 2 )}
  let!(:note) {FactoryGirl.create(:note, title: "NLS Parameter", content: "export NLS_LANG=AMERICAN_AMERICA.WE8ISO8859P1", user_id: 1 )}
  let!(:note3) {FactoryGirl.create(:note, title: "lorem", content: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", user_id: 1 )}
  let!(:note2) {FactoryGirl.create(:note, title: "NLS Parameter", content: "NLS2", user_id: 2 )}
  
  before do
    login_as(user)
  end
  
  # Scenario: User can search for notes in title without wildcards
  #   Given I am a registered user
  #   When I fill in a keyword and press search
  #   Then I see a the result page
  scenario "search for title name without wildcards" do
    visit notes_path
    fill_in "note_keywords", with: "NLS Parameter"
    click_button "search"
    expect(find('.search-results')).to have_content "NLS Parameter"
    expect(find('.search-results')).to have_content "NLS_LANG"
  end
  
  # Scenario: User can search only for his own notes in title without wildcards
  #   Given I am a registered user
  #   When I fill in a keyword and press search
  #   Then I see a the result page
  scenario "search for my own articels in title name without wildcards" do
    visit notes_path
    fill_in "note_keywords", with: "NLS Parameter"
    click_button "search"
    expect(find('.search-results')).not_to have_content "NLS2"
  end
  
  # Scenario: User can search for notes in title with wildcards (*)
  #   Given I am a registered user
  #   When I fill in a keyword and press search
  #   Then I see a the result page
  scenario "search for title name with wildcards" do
    visit notes_path
    fill_in "note_keywords", with: "NLS*"
    click_button "search"
    expect(find('.search-results')).to have_content "NLS Parameter"
  end
  
  
  # Scenario: User can search for notes in title or content with wildcards (*)
  #   Given I am a registered user
  #   When I fill in a keyword and press search
  #   Then I see a the result page
  scenario "search for title or content with wildcards" do
    visit notes_path
    fill_in "note_keywords", with: "AMERICAN*"
    click_button "search"
    expect(find('.search-results')).to have_content "NLS Parameter"
  end
  
  # Scenario: User can search for notes in content and gets keyword highlighted
  #   Given I am a registered user
  #   When I fill in a keyword and press search
  #   Then I see a the result page and 
  #   I see the given keyword highlighted
  scenario "search for title or content with wildcards" do
    visit notes_path
    fill_in "note_keywords", with: "consequat"
    click_button "search"
    expect(page).to have_content "lorem"
    expect(page).to have_content "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut a ... consequat ..."
    # keyword highlighted with class: "text-danger"
    #expect(page).to have_css('span.text-danger')
    expect(find('.search-results').find('span.text-danger')).to have_content('consequat')
  end
  
end


