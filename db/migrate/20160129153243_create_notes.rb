class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.belongs_to :user, null: false, index: true
      t.string :title, null: false, limit:100
      t.text :content, null:true

      t.timestamps null: false
    end
    add_foreign_key :notes, :users
    add_index :notes, :title
  end
end
