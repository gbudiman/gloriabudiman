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

ActiveRecord::Schema.define(:version => 20130110025320) do

  create_table "artists", :force => true do |t|
    t.string   "artist_name"
    t.string   "page_link"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "artists", ["artist_name"], :name => "index_artists_on_artist_name", :unique => true
  add_index "artists", ["page_link"], :name => "index_artists_on_page_link", :unique => true

  create_table "credits", :force => true do |t|
    t.integer  "image_id"
    t.integer  "artist_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "credits", ["artist_id", "image_id"], :name => "index_credits_on_artist_id_and_image_id", :unique => true
  add_index "credits", ["artist_id"], :name => "index_credits_on_artist_id"
  add_index "credits", ["image_id", "artist_id"], :name => "index_credits_on_image_id_and_artist_id", :unique => true
  add_index "credits", ["image_id"], :name => "index_credits_on_image_id"

  create_table "images", :force => true do |t|
    t.string   "image_link"
    t.string   "facebook_link"
    t.string   "gplus_link"
    t.boolean  "is_commercial"
    t.boolean  "is_filtered"
    t.boolean  "is_front_page"
    t.boolean  "is_published"
    t.integer  "view_count"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "images", ["facebook_link"], :name => "index_images_on_facebook_link", :unique => true
  add_index "images", ["gplus_link"], :name => "index_images_on_gplus_link", :unique => true
  add_index "images", ["image_link"], :name => "index_images_on_image_link", :unique => true

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.integer  "level"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
