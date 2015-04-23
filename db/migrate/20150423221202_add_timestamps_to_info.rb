class AddTimestampsToInfo < ActiveRecord::Migration
  def change
    add_column :info, :created_at, :datetime
    add_column :info, :updated_at, :datetime
  end
end