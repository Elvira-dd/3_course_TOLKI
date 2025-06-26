json.extract! @theme, :id, :name, :description
json.url api_v1_theme_url(@theme)
json.cover_url url_for(@theme.cover) if @theme.cover.attached?