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

ActiveRecord::Schema.define(:version => 20121204104330) do

  create_table "athletes", :force => true do |t|
    t.string   "full_name"
    t.string   "gender"
    t.string   "DOB"
    t.integer  "sport_id"
    t.integer  "country_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "athletes", ["country_id"], :name => "index_athletes_on_country_id"
  add_index "athletes", ["sport_id"], :name => "index_athletes_on_sport_id"

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "country_events", :force => true do |t|
    t.integer  "event_id"
    t.integer  "country_id"
    t.integer  "game_id"
    t.integer  "gold"
    t.integer  "silver"
    t.integer  "bronze"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "country_events", ["country_id"], :name => "index_country_events_on_country_id"
  add_index "country_events", ["event_id"], :name => "index_country_events_on_event_id"
  add_index "country_events", ["game_id"], :name => "index_country_events_on_game_id"

  create_table "country_games", :force => true do |t|
    t.integer  "country_id"
    t.integer  "game_id"
    t.integer  "gold"
    t.integer  "silver"
    t.integer  "bronze"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "country_games", ["country_id"], :name => "index_country_games_on_country_id"
  add_index "country_games", ["game_id"], :name => "index_country_games_on_game_id"

  create_table "event_bets", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "country_id"
    t.decimal  "amount",     :precision => 10, :scale => 0
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "event_bets", ["country_id"], :name => "index_event_bets_on_country_id"

  create_table "events", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "games", :force => true do |t|
    t.integer  "year"
    t.string   "season"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "medals", :force => true do |t|
    t.integer  "athlete_id"
    t.integer  "event_id"
    t.integer  "game_id"
    t.string   "medal"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "medals", ["athlete_id"], :name => "index_medals_on_athlete_id"
  add_index "medals", ["event_id"], :name => "index_medals_on_event_id"
  add_index "medals", ["game_id"], :name => "index_medals_on_game_id"

  create_table "sports", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
