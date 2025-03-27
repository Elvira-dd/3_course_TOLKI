json.extract! @podcast, :id, :name, :description, :created_at, :average_rating
json.cover @podcast.cover.filename.to_s if @podcast.cover.attached?
json.cover_url request.base_url + url_for(@podcast.cover) if @podcast.cover.attached?

# Если есть issues, то выводим их через частичный шаблон
json.set! :issues do
  json.array! @podcast.issues, partial: "api/v1/issues/issue", as: :issue
end

# Добавляем ссылку на сам подкаст
json.url api_v1_podcast_url(@podcast)