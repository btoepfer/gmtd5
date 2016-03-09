class CreateTags < ActiveRecord::Migration
  def change
    # Tags
    create_table :tags do |t|
      t.belongs_to :user, null: false, index: true
      t.string :name, null: false, limit:100

      t.timestamps null: false
    end
    
    add_foreign_key :tags, :users
    add_index :tags, :name
      
    # Intersection table
    create_table :notes_tags, id: false do |t|
          t.belongs_to :note, index: true
          t.belongs_to :tag, index: true
    end
    
    add_foreign_key :notes_tags, :notes
    add_foreign_key :notes_tags, :tags
    
  end
end
