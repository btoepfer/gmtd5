class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.belongs_to :user, index: true
      t.string :title, null: false
      t.text :content, null:true

      t.timestamps null: false
    end
    add_index :articles, :title
  end
end
