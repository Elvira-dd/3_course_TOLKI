json.extract! podcast, :id, :name, :description, :average_rating

json.created_at podcast.created_at.strftime('%d.%m.%Y')

# Используем Set для уникальности авторов
authors_set = Set.new
podcast.authors.each do |author|
  authors_set.add({
    id: author.id,
    name: author.user.profile.name,
    avatar_url: author.user.profile.avatar.attached? ? request.base_url + url_for(author.user.profile.avatar) : nil
  })
end

# Передаем авторов через json.set!
json.set! :authors, authors_set.to_a if authors_set.any?

# Используем Set для уникальности тем
themes_set = Set.new
podcast.themes.each do |theme|
  themes_set.add({
    id: theme.id,
    name: theme.name
  })
end

# Передаем темы через json.set!
json.set! :themes, themes_set.to_a if themes_set.any?

json.cover_url request.base_url + url_for(podcast.cover) if podcast.cover.attached?

# Передаем выпуски и посты
json.set! :issue do
  json.array! podcast.issues, partial: "api/v1/issues/issue", as: :issue
end

json.set! :posts do
  json.array! podcast.posts, partial: "api/v1/posts/post", as: :post
end

# URL подкаста
json.url api_v1_podcast_url(podcast)