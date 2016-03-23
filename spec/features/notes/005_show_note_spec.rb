require 'rails_helper'

# Feature: Zeige eine einzelne Notiz an
#   Als registrierter und angemeldeter Benutzer
#   möchte ich eine einzelne Notiz ansehen,
#   damit ich diese ansehen, bearbeiten oder löschen kann

RSpec.feature "Show Note" do

  # Wir legen zwei User an
  let!(:user) {FactoryGirl.create(:user, id: 1 )}
  let!(:user2) {FactoryGirl.create(:user, username: "User2", email: "User2@example.de", id: 2 )}
  
  # Und eine Notiz mit dem Tag #Oracle, die dem ersten User gehört
  let!(:note) {FactoryGirl.create(:note, id: 200, title: "NLS Parameter", content: "#Oracle: export NLS_LANG=AMERICAN_AMERICA.WE8ISO8859P1", user_id: 1 )}
  [201..203].each do |id| # IDs von 0 bis 11
    let!("note_#{id}") {FactoryGirl.create(:note, id: id, title: "Notiz - #{id}", content: "#Oracle: the #{id}. dog jumps over the lazy dog.", user_id: 1 )}
  end
  [300..302].each do |id| # IDs von 0 bis 11
    let!("note_#{id}") {FactoryGirl.create(:note, id: id, title: "Notiz - #{id}", content: "#MySQL: the #{id}. dog jumps over the lazy dog.", user_id: 1 )}
  end
  
  
  # Scenario: Ich kann die Einzelanzeige aufrufen und sehe die Notiz
  #   Als angemeldeter Benutzer:
  #   wenn ich die Show-Seite mit der ID 200 aufrufe,
  #   dann sehe ich diese Notiz 
  scenario "logged in" do
    login_as(user)
    visit note_path(id:200)
    
    # Die Notiz mit der ID 200 soll angezeigt werden
    expect(page).to have_content "NLS Parameter"
    expect(page).to have_content "#Oracle: export NLS_LANG=AMERICAN_AMERICA.WE8ISO8859P1"
  end
  
  # Scenario: Ich kann die Einzelanzeige aufrufen und verwandte Notizen
  #   Als angemeldeter Benutzer:
  #   wenn ich die Show-Seite mit der ID 200 aufrufe,
  #   dann sehe ich diese Notiz plus verwandte Notizen
  scenario "logged in" do
    login_as(user)
    visit note_path(id:200)
    
    # Die Notiz mit der ID 200 soll angezeigt werden
    expect(page).to have_content "NLS Parameter"
    
    # Neben der Notizen sollen weitere Notizen mit denselben Tags gezeigt werden
    expect(find('#related-notes').find('h5')).to have_content('Notiz - 201')
    expect(find('#related-notes').find('h5')).to have_content('Notiz - 202')
    expect(find('#related-notes').find('h5')).not_to have_content('Notiz - 302')
    
  end
  

  # Scenario: Als nicht angemeldeter Benutzer kann ich die Show-Seite nicht aufrufen
  #   Als Besucher:
  #   wenn ich die Show-Seite aufrufe,
  #   dann bekomme ich einen Hinweis, mich zuerst anzumelden
  scenario "Not logged in" do
    visit note_path(id:200)
    expect(page).to have_content I18n.t "devise.failure.unauthenticated"
  end
  
  # Scenario: Als  angemeldeter Benutzer kann ich die Show-Seite aufrufen, sehe aber nur meine Notizen
  #   Als angemeldeter Uer:
  #   wenn ich die Show-Seite aufrufe,
  #   dann bekomme ich einen Hinweis, dass die Notiz nicht existiert
  scenario "logged in as other user" do
    login_as(user2)
    visit note_path(id:200)
    expect(page).to have_content I18n.t(:note_not_found)
    expect(page).not_to have_content "#Oracle: export NLS_LANG=AMERICAN_AMERICA.WE8ISO8859P1"
  end
  
  
end


