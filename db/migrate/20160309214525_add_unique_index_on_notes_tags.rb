class AddUniqueIndexOnNotesTags < ActiveRecord::Migration
  def change
    add_index :notes_tags, [:note_id, :tag_id], {unique: true}
  end
end
