class AddUtcTimeToUsers < ActiveRecord::Migration

  def change


    add_column :users, :utc_time, :boolean, default: false



  end

end
