class AddMastodonToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mastodon, :string
    add_column :users, :mastodon_instance, :string
  end
end
