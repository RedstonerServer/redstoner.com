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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170319193517) do

  create_table "blogposts", force: :cascade do |t|
    t.string   "title"
    t.text     "content",        limit: 65535
    t.integer  "user_author_id", limit: 4
    t.integer  "user_editor_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content",        limit: 65535
    t.integer  "user_author_id", limit: 4
    t.integer  "user_editor_id", limit: 4
    t.integer  "blogpost_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forumgroups", force: :cascade do |t|
    t.string  "name"
    t.integer "position",      limit: 4
    t.integer "role_read_id",  limit: 4
    t.integer "role_write_id", limit: 4
  end

  create_table "forums", force: :cascade do |t|
    t.string  "name"
    t.integer "position",      limit: 4
    t.integer "role_read_id",  limit: 4
    t.integer "role_write_id", limit: 4
    t.integer "forumgroup_id", limit: 4
  end

  create_table "forums_labels", id: false, force: :cascade do |t|
    t.integer "forum_id", limit: 4
    t.integer "label_id", limit: 4
  end

  create_table "forumthreads", force: :cascade do |t|
    t.string   "title"
    t.text     "content",        limit: 65535
    t.boolean  "sticky",                       default: false
    t.boolean  "locked",                       default: false
    t.integer  "user_author_id", limit: 4
    t.integer  "user_editor_id", limit: 4
    t.integer  "forum_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "label_id",       limit: 4
  end

  create_table "info", force: :cascade do |t|
    t.string   "title"
    t.text     "content",    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "labels", force: :cascade do |t|
    t.string "name"
    t.string "color"
  end

  create_table "register_tokens", force: :cascade do |t|
    t.string "uuid",              null: false
    t.string "token",             null: false
    t.string "email",             null: false
  end

  add_index "register_tokens", ["uuid"], name: "index_register_tokens_on_uuid", unique: true, using: :btree

  create_table "roles", force: :cascade do |t|
    t.string  "name"
    t.integer "value", limit: 4
    t.string  "color"
  end

  create_table "badges", force: :cascade do |t|
    t.string  "name"
    t.string  "symbol"
    t.integer "value",  limit: 4
    t.string  "color"
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id",               null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "threadreplies", force: :cascade do |t|
    t.text     "content",        limit: 65535
    t.integer  "user_author_id", limit: 4
    t.integer  "user_editor_id", limit: 4
    t.integer  "forumthread_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "uuid",                                                      null: false
    t.string   "name",                                                      null: false
    t.string   "password_digest",                                           null: false
    t.string   "ign",                                                       null: false
    t.string   "email",                                                     null: false
    t.text     "about",                       limit: 65535
    t.string   "last_ip"
    t.string   "skype"
    t.boolean  "skype_public",                              default: false
    t.string   "youtube"
    t.string   "youtube_channelname"
    t.string   "twitter"
    t.string   "email_token"
    t.boolean  "confirmed",                                 default: false
    t.datetime "last_seen"
    t.integer  "role_id",                     limit: 4,                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "mail_own_thread_reply",                     default: true
    t.boolean  "mail_other_thread_reply",                   default: true
    t.boolean  "mail_own_blogpost_comment",                 default: true
    t.boolean  "mail_other_blogpost_comment",               default: true
    t.boolean  "mail_mention",                              default: true
    t.integer  "badge_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["ign"], name: "index_users_on_ign", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree
  add_index "users", ["skype"], name: "index_users_on_skype", unique: true, using: :btree
  add_index "users", ["twitter"], name: "index_users_on_twitter", unique: true, using: :btree
  add_index "users", ["uuid"], name: "index_users_on_uuid", unique: true, using: :btree
  add_index "users", ["youtube"], name: "index_users_on_youtube", unique: true, using: :btree

end
