class AddUsernameAndLanguageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string, {limit: 12}
    add_column :users, :language, :string, {limit: 2, default: "en", null: false}
    add_index :users, :username, {unique: true}
  end
end
