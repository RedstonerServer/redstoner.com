class FixUniqueness < ActiveRecord::Migration
  def change
    add_index :users, :uuid, unique: true
    add_index :users, :name, unique: true
    add_index :users, :ign, unique: true
    add_index :users, :email, unique: true
    add_index :users, :skype, unique: true
    add_index :users, :youtube, unique: true
    add_index :users, :twitter, unique: true

    add_index :register_tokens, :uuid, unique: :true
    add_index :register_tokens, :email, unique: :true
  end
end
