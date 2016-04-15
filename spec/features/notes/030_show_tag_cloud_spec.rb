require 'rails_helper'

# Feature: Zeige eine TagCloud mit den 30 meist genutzten
# Tags. Je nach Anzahl werden die Tags in vier unterschiedlichen
# Klassen dargestellt: tc-xs, tc-md, tc-lg, tc_xl

RSpec.feature "Show Tag Cloud" do

  # Wir legen einen User an
  let!(:user) {FactoryGirl.create(:user, id: 1 )}
  
  # Nun erstellen wir 200 Notizen mit den folgenden Tags: 
  #   5 mit #small => Class: tc-xs
  #  30 mit #mid   => Class: tc-md
  #  65 mit #large => Class: tc-lg
  # 100 mit #xl    => Class: tc-xl
  5.times do |id| 
    let!("note_#{id}") {FactoryGirl.create(:note, title: "Notiz - #{id} #small", content: "lorem ...", user_id: 1 )}
  end

  30.times do |id| 
    let!("note_#{id+5}") {FactoryGirl.create(:note, title: "Notiz - #{id} #mid", content: "lorem ...", user_id: 1 )}
  end
  
  65.times do |id| 
    let!("note_#{id+35}") {FactoryGirl.create(:note, title: "Notiz - #{id} #large", content: "lorem ...", user_id: 1 )}
  end
  
  100.times do |id| 
    let!("note_#{id+165}") {FactoryGirl.create(:note, title: "Notiz - #{id} #xl", content: "lorem ...", user_id: 1 )}
  end
  
  # Scenario: Index-Seite existiert und es werden 4 Tags angezeigt
  #   Als angemeldeter Benutzer:
  #   wenn ich die Index-Seite aufrufe,
  #   dann sehe ich eine TagCloud
  scenario "different classes" do
    login_as(user)
    visit notes_path
    #save_and_open_page
    expect(find(:xpath, "//*[@class='tc-xs']")).to have_content("small")
    expect(find(:xpath, "//*[@class='tc-md']")).to have_content("mid")
    expect(find(:xpath, "//*[@class='tc-lg']")).to have_content("large")
    expect(find(:xpath, "//*[@class='tc-xl']")).to have_content("xl")
  end
end