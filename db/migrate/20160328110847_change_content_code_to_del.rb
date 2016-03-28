class ChangeContentCodeToDel < ActiveRecord::Migration
  def change
    Note.all.each do | note |
      note.content.gsub!(/\B@(.*?)@\B/) { |r| "<del>#{$1}</del>"}
      note.update(content: note.content)
    end
  end
end
