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

ActiveRecord::Schema.define(:version => 20130802051521) do

  create_table "blogposts", :force => true do |t|
    t.string   "title"
    t.text     "text"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "comments", :force => true do |t|
    t.text     "text"
    t.integer  "user_id"
    t.integer  "blogpost_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "forumgroups", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "forums", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.integer  "forumgroup_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name",                                   :null => false
    t.string   "ign",                                    :null => false
    t.integer  "rank",                :default => 10,    :null => false
    t.boolean  "banned",              :default => false
    t.string   "email",                                  :null => false
    t.text     "about"
    t.string   "password_digest",                        :null => false
    t.string   "last_ip"
    t.string   "skype"
    t.boolean  "skype_public",        :default => false
    t.datetime "last_login"
    t.datetime "last_active"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "youtube"
    t.string   "youtube_channelname"
    t.string   "twitter"
  end

end
