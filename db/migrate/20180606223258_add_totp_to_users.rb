class AddTotpToUsers < ActiveRecord::Migration
  def change
    add_column :users, :totp, :string
  end
end
