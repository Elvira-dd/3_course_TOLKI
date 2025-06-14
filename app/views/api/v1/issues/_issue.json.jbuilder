json.extract! issue, :id, :name, :description, :podcast_id, :link
json.created_at issue.created_at.strftime('%d.%m.%Y')
json.cover_url issue.cover.attached? ? request.base_url + url_for(issue.cover) : nil
json.podcast_name issue.podcast&.name
json.set! :comments do
  json.array! issue.comments, partial: "api/v1/comments/comment", as: :comment
end