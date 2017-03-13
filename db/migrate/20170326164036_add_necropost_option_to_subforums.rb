class AddNecropostOptionToSubforums < ActiveRecord::Migration
  def change
    add_column :forums, :necropost_warning, :boolean, default: true
  end
end
