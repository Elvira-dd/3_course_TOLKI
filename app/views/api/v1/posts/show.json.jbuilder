json.extract! @post, :id, :title, :content, :date, :hashtag, :created_at, :issue_id
json.set! :comments do
json.array! @post.comments, partial: "api/v1/comments/comment", as: :comment
end
