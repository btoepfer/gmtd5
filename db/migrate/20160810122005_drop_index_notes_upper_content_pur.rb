class DropIndexNotesUpperContentPur < ActiveRecord::Migration
  def up
    remove_index :notes, name: 'notes_upper_content_pur'
  end
end
