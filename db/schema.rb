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

ActiveRecord::Schema.define(:version => 20110715201216) do

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.text     "body"
    t.string   "item_type"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["item_id"], :name => "index_comments_on_item_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "discussions", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "group_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "discussions", ["creator_id"], :name => "index_discussions_on_creator_id"
  add_index "discussions", ["group_id"], :name => "index_discussions_on_group_id"

  create_table "group_groups", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "group2_id"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "about"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["group_id"], :name => "index_memberships_on_group_id"
  add_index "memberships", ["role"], :name => "index_memberships_on_role"
  add_index "memberships", ["user_id"], :name => "index_memberships_on_user_id"

  create_table "tasks", :force => true do |t|
    t.string   "description"
    t.integer  "todo_id"
    t.integer  "status"
    t.integer  "list_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["todo_id"], :name => "index_tasks_on_todo_id"

  create_table "todos", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "group_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "todos", ["creator_id"], :name => "index_todos_on_creator_id"
  add_index "todos", ["group_id"], :name => "index_todos_on_group_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
