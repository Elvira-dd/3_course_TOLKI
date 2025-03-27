json.extract! podcast, :id, :name, :description, :created_at, :average_rating
json.cover podcast.cover.filename.to_s if podcast.cover.attached?
json.cover_url request.base_url + url_for(podcast.cover) if podcast.cover.attached?
json.set! :issue do
  json.array! podcast.issues, partial: "api/v1/issues/issue", as: :issue
end
json.url api_v1_podcast_url(podcast)