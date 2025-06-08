json.extract! @issue, :id, :name, :link, :cover_url,:podcast_id, :created_at, 
json.set! :comments do
  json.array! issue.comments, partial: "api/v1/comments/comment", as: :comment
end
