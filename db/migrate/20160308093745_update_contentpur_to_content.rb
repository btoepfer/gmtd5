class UpdateContentpurToContent < ActiveRecord::Migration
  def change
    Note.all.each do | note |
      note.update(content: note.content)
    end
  end
end
