require 'rails_helper'

RSpec.feature "User can login" do
  before do
    visit "/"
  end
  
  scenario "Login-Form" do
    fill_in "username", with: "bernd"
    fill_in "password", with: "123456"
    click_button "Login"
    expect(page).to have_content "Welcome Bernd"
  end
end
