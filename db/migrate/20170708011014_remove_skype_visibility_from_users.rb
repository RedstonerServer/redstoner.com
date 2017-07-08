class RemoveSkypeVisibilityFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :skype_public
    User.update_all skype: nil
  end
end
