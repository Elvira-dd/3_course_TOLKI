# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_12_24_084019) do
  create_table "authors", force: :cascade do |t|
    t.text "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "avatar"
  end

  create_table "authors_podcasts", id: false, force: :cascade do |t|
    t.integer "podcast_id", null: false
    t.integer "author_id", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.datetime "date"
    t.integer "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "user_name"
    t.string "integer"
    t.integer "comment_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
  end

  create_table "issues", force: :cascade do |t|
    t.string "name"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "podcast_id", null: false
    t.text "cover"
    t.index ["podcast_id"], name: "index_issues_on_podcast_id"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "likeable_type"
    t.integer "likeable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "podcasts", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cover"
    t.string "average_rating"
  end

  create_table "podcasts_themes", id: false, force: :cascade do |t|
    t.integer "podcast_id", null: false
    t.integer "theme_id", null: false
    t.index ["podcast_id", "theme_id"], name: "index_podcasts_themes_on_podcast_id_and_theme_id"
    t.index ["theme_id", "podcast_id"], name: "index_podcasts_themes_on_theme_id_and_podcast_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "date"
    t.boolean "is_comments_open"
    t.string "link"
    t.string "hashtag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "issue_id", null: false
    t.integer "user_id"
    t.index ["issue_id"], name: "index_posts_on_issue_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.text "bio"
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "level"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "text"
    t.integer "podcast_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "cover"
    t.index ["podcast_id"], name: "index_tags_on_podcast_id"
  end

  create_table "themes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cover"
    t.text "description"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "comments", "posts"
  add_foreign_key "issues", "podcasts"
  add_foreign_key "likes", "users"
  add_foreign_key "posts", "issues"
  add_foreign_key "tags", "podcasts"
end
