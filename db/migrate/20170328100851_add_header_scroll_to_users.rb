class AddHeaderScrollToUsers < ActiveRecord::Migration
  def change
    add_column :users, :header_scroll, :boolean, default: false
  end
end
