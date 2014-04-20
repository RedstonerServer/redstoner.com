class CreateInfo < ActiveRecord::Migration
  def change
    create_table :info do |t|
      t.string :title
      t.text :content
    end
  end
end
