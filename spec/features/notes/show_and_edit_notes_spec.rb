require 'rails_helper'

# Feature: Show and Edit Notes
#   As a registered and logged in user
#   I want to navigate to the notes detail page 
#   So I can create new notes, edit existing ones and show details
RSpec.feature "Show Note Details" do

  let!(:user) {FactoryGirl.create(:user, username: "User1", email: "User1@example.de",id: 1 )}
  let!(:user2) {FactoryGirl.create(:user, username: "User2", email: "User2@example.de", id: 2 )}
  let!(:note) {FactoryGirl.create(:note, id: 100, title: "Aut temporibus quod maxime", content: "Harum iusto quidem ut a. Totam accusamus neque voluptatem architecto. Illo voluptatem sed rerum sequi dicta. Numquam debitis laudantium est voluptas dolorum doloribus", user_id: 1 )}
  let!(:note2) {FactoryGirl.create(:note, id: 101, title: "Veritatis itaque qui quae ut", content: "Perferendis atque rerum veritatis perspiciatis iusto repellendus voluptatem. Numquam sed nulla temporibus. Distinctio reiciendis eius voluptatem corrupti et aut exercitationem. Ad debitis cupiditate corrupti.", user_id: 2 )}
  
  before do
    login_as(user)
  end
  
  # Scenario: User can search for notes and show details page
  #   Given I am a registered user
  #   When I search for a note 
  #   Then I see a the result page and can navigate to the details page
  scenario "search for note to show details" do
    visit notes_path
    fill_in "note_keywords", with: "Aut temporibus*"
    click_button "search"
    expect(page).to have_content "Aut temporibus quod maxime"
    expect(page).to have_content "Harum iusto quidem ut a. Totam accusamus neque voluptatem architecto."
    click_on('Aut temporibus quod maxime')
    expect(page).to have_content "Aut temporibus quod maxime"
  end
  
  # Scenario: User cannot show notes from other users
  #   Given I am a registered user
  #   When I try to open the detail page for a notes of another user 
  #   Then I do not see the notes
  scenario "show note of another user" do
    visit note_path(id: 101)
    expect(page).to have_content I18n.t("note_not_found")
    expect(page).not_to have_content "Veritatis itaque qui quae ut"
  end
  
  # Scenario: User wants to edit note
  #   Given I am a registered user
  #   When I click on link "edit note" 
  #   Then I see a form for editing an existing note
  scenario "edit note" do
    visit note_path(id: 100)
    expect(page).to have_content "Aut temporibus quod maxime"
    click_on I18n.t("edit_note")
    expect(page).to have_field :note_title
    fill_in :note_title, with: "Geänderte Notiz"
    find('#note_content').set('The quick brown fox jumps over the lazy dog.')
    click_on I18n.t("save")
    expect(page).to have_content "Geänderte Notiz"
    expect(page).to have_content "The quick brown fox jumps over the lazy dog."
  end
  
  # Scenario: User wants to create a new note
  #   Given I am a registered user
  #   When I click on link "new note" 
  #   Then I see a form for creating an existing note
  scenario "create note" do
    visit notes_path
    click_on I18n.t("create_note")
    expect(page).to have_field :note_title
    fill_in :note_title, with: "Neue Notiz"
    find('#note_content').set('The quick brown fox jumps over the lazy dog.')
    click_on I18n.t("create")
    expect(page).to have_content "Neue Notiz"
    expect(page).to have_content "The quick brown fox jumps over the lazy dog."
  end
  
  # Scenario: Notes shows formatted content
  #   Given I am a registered user
  #   When I use @@ or # in my note 
  #   Then I see a the content formated
  scenario "edit note" do
    visit note_path(id: 100)
    click_on I18n.t("edit_note")
    expect(page).to have_field :note_title
    fill_in :note_title, with: "Formatierte Notiz"
    find('#note_content').set('#The quick brown #fox @jumps@ over the lazy #dog. And her#his it #is')
    click_on I18n.t("save")
    expect(page).to have_content "Formatierte Notiz"
    expect(find('.trix-content').find('code')).to have_content('jumps')
    expect(find('.trix-content').find('mark', :text => '#fox'))
    expect(find('.trix-content').find('mark', :text => '#dog'))
    expect(find('.trix-content').find('mark', :text => '#The'))
    expect(find('.trix-content').find('mark', :text => '#is'))
    expect(page).not_to have_selector('mark', :text => '#his')
  end
  
  # Scenario: Notes with tags generates tags and association
  #   Given I am a registered user
  #   When I use #text in my note 
  #   Then tags are created and associated to this not
  scenario "edit note" do
    visit note_path(id: 100)
    click_on I18n.t("edit_note")
    expect(page).to have_field :note_title
    fill_in :note_title, with: "Notiz mit Tags"
    find('#note_content').set('Hier stehen #tags und #togs im Inhalt, #tags sogar zweimal')
    click_on I18n.t("save")
    expect(page).to have_content "Notiz mit Tags"
    #expect(find('.trix-content').find('mark', {:text => '#tags', :count=>2}))
    expect(find('.trix-content').find('mark', :text => '#togs'))
    # Find Tags and association
    t = Tag.where("name=?", "TAGS")
    expect(t.count).to eq(0)
    t = Tag.where("name=?", "tags")
    expect(t.count).to eq(1)
    t = Tag.where("name_upper=?", "TOGS")
    expect(t.count).to eq(1)
    t = Tag.joins(:notes).where("notes.id=?", 100)
    expect(t.count).to eq(2)
  end
  
end


