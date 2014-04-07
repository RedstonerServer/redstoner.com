# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 10) do

  create_table "blogposts", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_author_id"
    t.integer  "user_editor_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "user_author_id"
    t.integer  "user_editor_id"
    t.integer  "blogpost_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "forumgroups", :force => true do |t|
    t.string  "name"
    t.integer "position"
    t.integer "role_read_id"
    t.integer "role_write_id"
  end

  create_table "forums", :force => true do |t|
    t.string  "name"
    t.integer "position"
    t.integer "role_read_id"
    t.integer "role_write_id"
    t.integer "forumgroup_id"
  end

  create_table "forumthreads", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.boolean  "sticky",         :default => false
    t.boolean  "locked",         :default => false
    t.integer  "user_author_id"
    t.integer  "user_editor_id"
    t.integer  "forum_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "register_tokens", :primary_key => "uuid", :force => true do |t|
    t.string "token", :limit => 6, :null => false
    t.string "email",              :null => false
  end

  create_table "roles", :force => true do |t|
    t.string  "name"
    t.integer "value"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "threadreplies", :force => true do |t|
    t.text     "content"
    t.integer  "user_author_id"
    t.integer  "user_editor_id"
    t.integer  "forumthread_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "uuid",                                   :null => false
    t.string   "name",                                   :null => false
    t.string   "password_digest",                        :null => false
    t.string   "ign",                                    :null => false
    t.string   "email",                                  :null => false
    t.text     "about"
    t.string   "last_ip"
    t.string   "skype"
    t.boolean  "skype_public",        :default => false
    t.string   "youtube"
    t.string   "youtube_channelname"
    t.string   "twitter"
    t.boolean  "donor",               :default => false
    t.string   "email_token"
    t.boolean  "confirmed",           :default => false
    t.datetime "last_seen"
    t.integer  "role_id",                                :null => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

end
