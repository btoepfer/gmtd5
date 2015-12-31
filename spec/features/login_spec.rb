require 'rails_helper'

RSpec.feature "User can login" do
  before do
    visit "/"
  end
  
  scenario "Login-Form" do
    fill_in "User", with: "bernd"
    fill_in "Password", with: "123456"
    click_button "OK"
    expect(page).to have_content "Welcome Bernd"
  end
end
