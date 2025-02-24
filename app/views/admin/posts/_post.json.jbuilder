json.extract! post, :id, :title, :content, :date,  :hashtag, :created_at, :updated_at
json.url post_url(post, format: :json)
