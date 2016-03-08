class ChangeIndexOnContentToContentpur < ActiveRecord::Migration
  def up
    execute %{
      drop index notes_upper_content
    }
    execute %{
      create index notes_upper_content_pur
      on notes(upper(content_pur) varchar_pattern_ops)
    }
  end
  
  def down
    remove_index :notes, name: 'notes_upper_content_pur'
  end
end
