class AddUniqueIndexOnTagName < ActiveRecord::Migration

  def up
    execute %{
      create unique index tags_upper_name
      on tags(upper(name))
    }
  end
  
  def down
    remove_index :tags, name: 'tags_upper_name'
  end
end
