class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.attachment :doc
      t.text :doc_content, null:true
      t.timestamps null: false
      t.belongs_to :note, null: false, index: true
    end
    add_foreign_key :attachments, :notes
  end
end
