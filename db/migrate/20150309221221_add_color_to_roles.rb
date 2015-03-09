class AddColorToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :color, :string
  end
end
