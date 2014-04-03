class CreateRegisterTokens < ActiveRecord::Migration
  def change
     create_table :register_tokens, primary_key: :uuid do |t|
       t.string :uuid, limit: 32, unique: true, primary: true, null: false
       t.string :token, limit: 6, null: false
       t.string :email, unique: true, null: false
     end
     change_column :register_tokens, :uuid, :string
  end
end