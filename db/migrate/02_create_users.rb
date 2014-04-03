class CreateUsers < ActiveRecord::Migration
  def change
    create_table   :users do |t|
      t.string     :uuid, unique: true, null: false
      t.string     :name, unique: true, null: false
      t.string     :password_digest, null: false
      t.string     :ign, unique: true, null: false
      t.string     :email, unique: true, null: false
      t.text       :about
      t.string     :last_ip
      t.string     :skype, unique: true
      t.boolean    :skype_public, default: false
      t.string     :youtube, unique: true
      t.string     :youtube_channelname
      t.string     :twitter, unique: true
      t.boolean    :donor, default: false
      t.string     :email_token
      t.boolean    :confirmed, default: false
      t.datetime   :last_seen

      t.references :role, null: false

      t.timestamps
    end
  end
end