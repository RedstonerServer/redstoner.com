class RemoveIndexEmailFromRegisterTokens < ActiveRecord::Migration
  def change
    remove_index :register_tokens, :email
  end
end
