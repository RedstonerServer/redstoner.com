class AddBadgeIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :badge_id, :integer
    add_column :users, :badge_id, :integer, default: 0
    User.where(donor: true).update_all(badge_id: 1)
    remove_column :users, :donor
  end
end
