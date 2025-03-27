json.extract! issue, :id, :name, :description, :created_at, :podcast_id
json.cover_url issue.cover.attached? ? request.base_url + url_for(issue.cover) : nil