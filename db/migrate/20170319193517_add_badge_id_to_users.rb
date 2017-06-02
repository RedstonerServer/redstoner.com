class AddBadgeIdToUsers < ActiveRecord::Migration
  def change

    create_table "badges", force: :cascade do |t|
      t.string  "name"
      t.string  "symbol"
      t.string  "color"
    end

    dbadge = Badge.create!({name: "donor", symbol: "$", color: "#f60"})

    add_column :users, :badge_id, :integer, default: 0
    User.where(donor: true).update_all(badge_id: dbadge.id)
    remove_column :users, :donor
  end
end
