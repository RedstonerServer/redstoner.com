class CreateBadgeassociations < ActiveRecord::Migration
  def change
    create_table :badgeassociations do |t|
      t.references :badge
      t.references :forum
      t.references :forumgroup
      t.integer :permission #1 = read, 2 = write
    end
  end
end
