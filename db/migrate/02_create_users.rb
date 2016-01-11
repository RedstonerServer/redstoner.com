class CreateUsers < ActiveRecord::Migration
  def change
    create_table   :users do |t|
      t.string     :uuid, null: false
      t.string     :name, null: false
      t.string     :password_digest, null: false
      t.string     :ign, null: false
      t.string     :email, null: false
      t.text       :about
      t.string     :last_ip
      t.string     :skype
      t.boolean    :skype_public, default: false
      t.string     :youtube
      t.string     :youtube_channelname
      t.string     :twitter
      t.boolean    :donor, default: false
      t.boolean    :retired, default: false
      t.boolean    :mit, default: false
      t.boolean    :dev, default: false
      t.boolean    :lead, default: false
      t.string     :email_token
      t.boolean    :confirmed, default: false
      t.datetime   :last_seen

      t.references :role, null: false, default: Role.get(:normal)

      t.timestamps
    end
  end
end