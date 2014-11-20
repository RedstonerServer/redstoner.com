class AddLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string :name
      t.references :role
    end

    add_column :forumthreads, :label_id, :integer

    create_table :forums_labels, id: false do |t|
      t.references :forum
      t.references :label
    end
  end
end