class DropForumsLabels < ActiveRecord::Migration
  def change
    drop_table :forums_labels
  end
end
