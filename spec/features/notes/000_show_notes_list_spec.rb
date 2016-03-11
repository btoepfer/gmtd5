require 'rails_helper'

# Feature: Zeige eine Liste der letzen 10 Notizen
#   Als registrierter und angemeldeter Benutzer
#   möchte ich eine Liste meiner letzten (10) Notizen sehen,
#   damit ich mir einzelne Notizen ansehen, bearbeiten oder löschen kann

RSpec.feature "Show Note index" do

  # Wir legen einen User an
  let!(:user) {FactoryGirl.create(:user, id: 1 )}
  12.times do |id| # IDs von 0 bis 11
    let!("note_#{id}") {FactoryGirl.create(:note, id: id, title: "Notiz - #{id}", content: "the #{id}. dog jumps over the lazy dog.", user_id: 1 )}
  end
  
  # Scenario: Index-Seite existiert und es werden die letzten 10 Notizen gezeigt
  #   Als angemeldeter Benutzer:
  #   wenn ich die Index-Seite aufrufe,
  #   dann sehe ich meine letzten 10 Notizen
  scenario "logged in" do
    login_as(user)
    visit notes_path
    # Es sollen zehn Notizen als Liste angezeigt werden
    expect(page).to have_selector('#search-results .list-group .list-group-item', :count => 10)
    
    # Die letzte Notiz id=11 soll angezeigt werden
    expect(page).to have_content "the 11. dog jumps over the lazy dog."
    
    # Die erste Notiz soll nicht angezeigt werden, da absteigend nach IDs sortiert werden soo
    expect(page).not_to have_content "the 0. dog jumps over the lazy dog."
  end
  
  # Scenario: Index-Seite existiert und es werden die letzten 10 Notizen gezeigt
  #   Als angemeldeter Benutzer:
  #   wenn ich die Index-Seite aufrufe,
  #   dann sehe ich meine letzten 10 Notizen
  scenario "show edit/delete link in list" do
    login_as(user)
    visit notes_path
    
    # Bei jeder Notiz wird ein Link zum Ändern bzw. Löschen der Notiz eingeblendet
    expect(page).to have_content "the 11. dog jumps over the lazy dog."
    expect(page).to have_selector('#search-results .list-group .list-group-item a')
    expect(page).to have_link(I18n.t(:edit_note), {:href=>"/notes/11/edit"})
  end
  
  # Scenario: Als nicht angemeldeter Benutzer kann ich die Index-Seite nicht aufrufen
  #   Als Besucher:
  #   wenn ich die Index-Seite aufrufe,
  #   dann bekomme ich einen Hinweis, mich zuerst anzumelden
  scenario "Not logged in" do
    visit notes_path
    expect(page).to have_content I18n.t "devise.failure.unauthenticated"
  end
  
  
end


