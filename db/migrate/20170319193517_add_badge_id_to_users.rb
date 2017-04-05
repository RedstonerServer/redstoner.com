class AddBadgeIdToUsers < ActiveRecord::Migration

  def change
    add_column :users, :badge_id, :integer
    remove_column :users, :donor
  end

  create_table "badges", force: :cascade do |t|
    t.string  "name"
    t.string  "symbol"
    t.integer "value", limit: 4
    t.string  "color"
  end

end
