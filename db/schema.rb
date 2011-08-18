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

ActiveRecord::Schema.define(:version => 20110818043124) do

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
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "discussions", ["creator_id"], :name => "index_discussions_on_creator_id"
  add_index "discussions", ["group_id"], :name => "index_discussions_on_group_id"

  create_table "documents", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "group_id"
    t.string   "title"
    t.text     "description"
    t.string   "doc_file_name"
    t.string   "doc_content_type"
    t.integer  "doc_file_size"
    t.datetime "doc_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documents", ["creator_id"], :name => "index_documents_on_creator_id"
  add_index "documents", ["group_id"], :name => "index_documents_on_group_id"

  create_table "group_connections", :force => true do |t|
    t.integer  "group_id"
    t.integer  "group_b_id"
    t.integer  "status",     :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_connections", ["group_b_id"], :name => "index_group_connections_on_group_b_id"
  add_index "group_connections", ["group_id"], :name => "index_group_connections_on_group_id"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "about"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  add_index "groups", ["creator_id"], :name => "index_groups_on_creator_id"

  create_table "interactions", :force => true do |t|
    t.integer  "user_id"
    t.string   "item_type"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "summary"
  end

  create_table "item_shares", :force => true do |t|
    t.integer  "item_id"
    t.string   "item_type"
    t.integer  "group_id"
    t.integer  "creator_id"
    t.boolean  "admins_only", :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_shares", ["creator_id"], :name => "index_item_shares_on_creator_id"
  add_index "item_shares", ["group_id"], :name => "index_item_shares_on_group_id"
  add_index "item_shares", ["item_id"], :name => "index_item_shares_on_item_id"

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "role"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_pending", :default => true, :null => false
  end

  add_index "memberships", ["group_id"], :name => "index_memberships_on_group_id"
  add_index "memberships", ["role"], :name => "index_memberships_on_role"
  add_index "memberships", ["user_id"], :name => "index_memberships_on_user_id"

  create_table "tasks", :force => true do |t|
    t.string   "description"
    t.integer  "todo_id"
    t.integer  "status"
    t.integer  "list_order"
    t.integer  "task_num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["todo_id"], :name => "index_tasks_on_todo_id"

  create_table "todos", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "group_id"
    t.string   "title"
    t.text     "description"
    t.integer  "tasks_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "todos", ["creator_id"], :name => "index_todos_on_creator_id"
  add_index "todos", ["group_id"], :name => "index_todos_on_group_id"

  create_table "updates_requests", :force => true do |t|
    t.string   "email"
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "updates_requests", ["email"], :name => "index_updates_requests_on_email", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "about"
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.text     "filter_state"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
