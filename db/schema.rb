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

ActiveRecord::Schema.define(:version => 20150427133154) do

  create_table "contributions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "idea_id"
    t.text     "body"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.datetime "accepted_at"
    t.datetime "rejected_at"
    t.text     "body_html"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "ideas", :force => true do |t|
    t.integer  "problem_id"
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.text     "description_html"
  end

  create_table "problems", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image"
    t.datetime "ideas_deadline"
    t.datetime "voting_deadline"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "user_id"
    t.text     "objectives"
    t.string   "hashtag"
    t.integer  "organization_id"
  end

  create_table "updates", :force => true do |t|
    t.string   "image"
    t.string   "title"
    t.text     "body"
    t.integer  "problem_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "user_id"
    t.string   "facebook_post_id"
    t.text     "message"
    t.text     "video_html"
    t.string   "video"
    t.text     "lead"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "image"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "uid"
    t.boolean  "admin"
    t.string   "token"
  end

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "idea_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
