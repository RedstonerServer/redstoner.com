class AddNecroLengthToForums < ActiveRecord::Migration
  def change
    add_column :forums, :necro_length, :integer
  end
end
