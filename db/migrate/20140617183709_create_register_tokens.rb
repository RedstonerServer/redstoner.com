class CreateRegisterTokens < ActiveRecord::Migration
  def change
     create_table :register_tokens do |t|
       t.string :uuid, limit: 32, primary: true, null: false
       t.string :token, limit: 6, null: false
       t.string :email, null: false
     end
  end
end