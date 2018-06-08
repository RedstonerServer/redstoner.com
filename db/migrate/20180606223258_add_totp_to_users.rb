class AddTotpToUsers < ActiveRecord::Migration
  def change
    add_column :users, :totp_secret, :string
    add_column :users, :totp_enabled, :boolean, default: false
  end
end
