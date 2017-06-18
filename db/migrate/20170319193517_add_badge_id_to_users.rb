class AddBadgeIdToUsers < ActiveRecord::Migration
  def change

    create_table "badges", force: :cascade do |t|
      t.string  "name"
      t.string  "symbol"
      t.string  "color"
    end

    Badge.create!({name: "none", symbol: "", color: "#000"})
    dbadge = Badge.create!({name: "donor", symbol: "$", color: "#f60"})

    add_column :users, :badge_id, :integer, default: 1
    User.where(donor: true).update_all(badge_id: dbadge.id)
    remove_column :users, :donor
  end
end
