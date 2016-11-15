class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.belongs_to :user, null: false, index: true
      t.string :name, null: false, limit:100
      t.integer :status, null: false, default: 0
      t.date :due_date, null: true
      t.integer :sort, null: false, default: 1
      t.text :content, null: true

      t.timestamps
    end
    
    add_foreign_key :tasks, :users
    add_index :tasks, :status
    
  end
end
