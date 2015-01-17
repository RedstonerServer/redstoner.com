class RemoveRoleFromLabel < ActiveRecord::Migration
  def change
    remove_column :labels, :role_id
  end
end
