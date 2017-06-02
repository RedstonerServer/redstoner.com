class CreateRoles < ActiveRecord::Migration
  def change
     create_table :roles do |t|
       t.string :name
       t.integer :value
     end
  end
end
