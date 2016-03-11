class AddUpperNameToTags < ActiveRecord::Migration
  def change
    add_column :tags, :name_upper, :string
    remove_index :tags, :name
    add_index :tags, :name_upper, unique: true
  end
end
