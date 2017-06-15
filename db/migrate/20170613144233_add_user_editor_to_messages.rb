class AddUserEditorToMessages < ActiveRecord::Migration
  def change
    add_reference :messages, :user_editor
  end
end
