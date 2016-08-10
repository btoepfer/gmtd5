class AddTriggerOnNotes < ActiveRecord::Migration
  def up
    execute %{
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON notes 
      FOR EACH ROW 
      EXECUTE PROCEDURE
        tsvector_update_trigger(index_col_title_content, 'pg_catalog.german', title, content);
    }
  end
  
  def down
    execute %{
      DROP TRIGGER tsvectorupdate on notes;
    }
  end
end
