class AddIndexColOnNotes < ActiveRecord::Migration
  def up
    execute %{
      ALTER TABLE notes ADD COLUMN index_col_title_content tsvector;
      }
    execute %{
      UPDATE notes SET index_col_title_content =
           to_tsvector('german', coalesce(title,'') || ' ' || coalesce(content,''));
      }
    execute %{
      CREATE INDEX title_content_idx ON notes USING gin(index_col_title_content);
    }
  end
  
  def down
    remove_index :notes, name: 'title_content_idx'
    remove_column :notes, :index_col_title_content
  end
end
