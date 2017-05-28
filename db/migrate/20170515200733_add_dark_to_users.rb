class AddDarkToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dark, :boolean, default: false
  end
end
