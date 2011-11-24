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

ActiveRecord::Schema.define(:version => 20111124050202) do

  create_table "engine_schema_info", :id => false, :force => true do |t|
    t.string  "engine_name"
    t.integer "version"
  end

  create_table "events", :force => true do |t|
    t.datetime "created_at"
    t.datetime "scheduled_time"
    t.string   "headline",       :limit => 200, :default => "",    :null => false
    t.text     "body",                                             :null => false
    t.integer  "user_id",                       :default => 0,     :null => false
    t.boolean  "approved",                      :default => false
  end

  create_table "for_hires", :force => true do |t|
    t.text    "blurb",                                  :null => false
    t.string  "email",   :limit => 200, :default => "", :null => false
    t.string  "title",   :limit => 200, :default => "", :null => false
    t.integer "user_id"
  end

  create_table "list_mails", :force => true do |t|
    t.string   "subject", :limit => 256,                 :null => false
    t.string   "replyto", :limit => 256
    t.string   "from",    :limit => 128,                 :null => false
    t.string   "to",      :limit => 128,                 :null => false
    t.datetime "stamp",                                  :null => false
    t.text     "body",                                   :null => false
    t.string   "mailid",  :limit => 256, :default => "", :null => false
  end

  create_table "messages_messages", :id => false, :force => true do |t|
    t.integer "parent_id", :null => false
    t.integer "child_id",  :null => false
  end

  create_table "openings", :force => true do |t|
    t.datetime "created_at"
    t.string   "headline",   :limit => 100, :default => "", :null => false
    t.text     "body",                                      :null => false
    t.integer  "user_id"
  end

  create_table "projects", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "url"
    t.string   "source_url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "sessions_session_id_index"

  create_table "users", :force => true do |t|
    t.string   "login",           :limit => 80, :default => "", :null => false
    t.string   "salted_password", :limit => 40, :default => "", :null => false
    t.string   "email",           :limit => 60, :default => "", :null => false
    t.string   "firstname",       :limit => 40
    t.string   "lastname",        :limit => 40
    t.string   "salt",            :limit => 40, :default => "", :null => false
    t.integer  "verified",                      :default => 0
    t.string   "security_token",  :limit => 40
    t.datetime "token_expiry"
    t.integer  "deleted",                       :default => 0
    t.datetime "logged_in_at"
    t.date     "delete_after"
    t.string   "role",            :limit => 10
    t.string   "gravatar_email"
  end

  add_index "users", ["login"], :name => "uidx"

end
