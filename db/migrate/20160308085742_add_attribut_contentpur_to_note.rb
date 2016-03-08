class AddAttributContentpurToNote < ActiveRecord::Migration
  def change
    add_column :notes, :content_pur, :text
  end
end
