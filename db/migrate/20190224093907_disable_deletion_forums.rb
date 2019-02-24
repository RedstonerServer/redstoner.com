class DisableDeletionForums < ActiveRecord::Migration
  def change
    add_column :forums, :disable_deletion, :boolean
  end
end
