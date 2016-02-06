class AddFunctionBasedIndexToNotes < ActiveRecord::Migration
  def up
    execute %{
      create index notes_upper_title
      on notes(upper(title) varchar_pattern_ops)
    }
    execute %{
      create index notes_upper_content
      on notes(upper(content) varchar_pattern_ops)
    }
  end
  
  def down
    remove_index :notes, name: 'notes_upper_title'
    remove_index :notes, name: 'notes_upper_content'
  end
end
