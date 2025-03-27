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

ActiveRecord::Schema[7.2].define(version: 2025_03_27_081415) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "authors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "exten_bio"
    t.index ["user_id"], name: "index_authors_on_user_id"
  end

  create_table "authors_podcasts", id: false, force: :cascade do |t|
    t.integer "author_id", null: false
    t.integer "podcast_id", null: false
    t.index ["author_id", "podcast_id"], name: "index_authors_podcasts_on_author_id_and_podcast_id"
    t.index ["podcast_id", "author_id"], name: "index_authors_podcasts_on_podcast_id_and_author_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "user_name"
    t.string "integer"
    t.integer "comment_id"
    t.integer "issue_id"
    t.string "commentable_type"
    t.integer "commentable_id"
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
  end

  create_table "dislikes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "dislikeable_type", null: false
    t.integer "dislikeable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dislikeable_type", "dislikeable_id"], name: "index_dislikes_on_dislikeable"
    t.index ["user_id"], name: "index_dislikes_on_user_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "favoritable_type", null: false
    t.integer "favoritable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["favoritable_type", "favoritable_id"], name: "index_favorites_on_favoritable"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "issues", force: :cascade do |t|
    t.string "name"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "podcast_id", null: false
    t.text "description"
    t.string "cover"
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

  create_table "playlist_items", force: :cascade do |t|
    t.integer "playlist_id", null: false
    t.integer "issue_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_playlist_items_on_issue_id"
    t.index ["playlist_id"], name: "index_playlist_items_on_playlist_id"
  end

  create_table "playlists", force: :cascade do |t|
    t.string "name"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_playlists_on_user_id"
  end

  create_table "podcasts", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cover"
    t.string "average_rating"
    t.json "external_links"
    t.integer "author_id"
    t.boolean "is_audio"
    t.index ["author_id"], name: "index_podcasts_on_author_id"
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
    t.string "hashtag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "podcast_id"
    t.integer "author_id"
    t.index ["author_id"], name: "index_posts_on_author_id"
    t.index ["podcast_id"], name: "index_posts_on_podcast_id"
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

  create_table "reviews", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "podcast_id", null: false
    t.integer "rating"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "tags", default: []
    t.index ["podcast_id"], name: "index_reviews_on_podcast_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
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
    t.string "jti", null: false
    t.boolean "is_author", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "authors", "users"
  add_foreign_key "dislikes", "users"
  add_foreign_key "favorites", "users"
  add_foreign_key "issues", "podcasts"
  add_foreign_key "likes", "users"
  add_foreign_key "playlist_items", "issues"
  add_foreign_key "playlist_items", "playlists"
  add_foreign_key "playlists", "users"
  add_foreign_key "podcasts", "authors"
  add_foreign_key "posts", "authors"
  add_foreign_key "posts", "podcasts"
  add_foreign_key "reviews", "podcasts"
  add_foreign_key "reviews", "users"
  add_foreign_key "tags", "podcasts"
end
