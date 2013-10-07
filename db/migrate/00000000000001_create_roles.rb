class CreateRoles < ActiveRecord::Migration
  def up
     create_table :roles do |t|
       t.string :name
       t.integer :value
     end
  end

  def down
  end
end
