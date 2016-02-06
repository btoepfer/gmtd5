class RemoveIndexOnTitleFromNotes < ActiveRecord::Migration
  def up
    remove_index :notes, name: 'index_notes_on_title'
  end
  
  def down
    add_index :notes, :title
  end
  
end
