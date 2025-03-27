json.extract! post, :id, :title, :content, :created_at, :updated_at, :podcast_id

# Добавляем комментарии к посту
json.set! :comments do
  json.array! post.comments, partial: "api/v1/comments/comment", as: :comment
end