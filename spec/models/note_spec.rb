require 'rails_helper'

RSpec.describe Note, type: :model do
  describe "content_pur" do
    # User wird angelegt
    let(:user) {
      User.create!(email: "foox@bctoepfer.de", 
                   password: "fkdjfkdsjf", 
                   password_confirmation: "fkdjfkdsjf")
    }
    
    # Notiz wird für den User angelegt
    let(:note) {
        user.notes.create!(title: "Titel EINS",
                     content: "<div>The&nbsp;<strong>quick&nbsp;</strong>brown&nbsp;<em>fox jumps</em>&nbsp;over the lazy&nbsp;<a href='http://dogfever.de'>dog</a>.</div>")
    }
    
    # Nun prüfen wir, ob nach dem Speichern der Inhalt von "content_pur"
    # dem Inhalt von "content" ohne die HMTL-Tags entspricht.
    it "content_pur should contain text without html-tags" do
      expect(note.content_pur).to eq("The quick brown fox jumps over the lazy dog.")
      expect(note.content).to eq("<div>The&nbsp;<strong>quick&nbsp;</strong>brown&nbsp;<em>fox jumps</em>&nbsp;over the lazy&nbsp;<a href='http://dogfever.de'>dog</a>.</div>")
    end
    
  end

end
