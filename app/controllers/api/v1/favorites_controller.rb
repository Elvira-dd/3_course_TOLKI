class Api::V1::FavoritesController < ApplicationController

  def index
    if current_user
      favorite_podcasts = current_user.favorite_podcasts.includes(
        authors: { user: { profile: { avatar_attachment: :blob } } },
        themes: [],
        cover_attachment: :blob
      )
      favorite_issues = current_user.favorite_issues.includes(
        :podcast,
        comments: { user: { profile: { avatar_attachment: :blob } } },
        cover_attachment: :blob
      )
    else
      favorite_podcasts = Podcast.where(id: [3, 4]).includes(
        authors: { user: { profile: { avatar_attachment: :blob } } },
        themes: [],
        cover_attachment: :blob
      )
      favorite_issues = Issue.where(id: [9, 10, 13]).includes(
        :podcast,
        comments: { user: { profile: { avatar_attachment: :blob } } },
        cover_attachment: :blob
      )
    end

    render json: {
      podcasts: favorite_podcasts.map { |podcast| podcast_json(podcast) },
      issues: favorite_issues.map { |issue| issue_json(issue) }
    }
  end

  private

  def podcast_json(podcast)
    {
      id: podcast.id,
      name: podcast.name,
      description: podcast.description,
      average_rating: podcast.average_rating,
      created_at: podcast.created_at.strftime("%d.%m.%Y"),
      authors: podcast.authors.map do |author|
        {
          id: author.id,
          name: author.user.profile.name,
          avatar_url: author.user.profile.avatar.attached? ? url_for(author.user.profile.avatar) : nil
        }
      end,
      themes: podcast.themes.map { |theme| { id: theme.id, name: theme.name } },
      cover_url: podcast.cover.attached? ? url_for(podcast.cover) : nil,
      issue: [],
      posts: [],
      url: api_v1_podcast_url(podcast)
    }
  end

  def issue_json(issue)
    {
      id: issue.id,
      name: issue.name,
      description: issue.description,
      podcast_id: issue.podcast_id,
      link: issue.link,
      is_audio: issue.is_audio,
      podcast_name: issue.podcast.name,
      created_at: issue.created_at.strftime("%d.%m.%Y"),
      cover_url: issue.cover.attached? ? url_for(issue.cover) : nil,
      comments: issue.comments.map do |comment|
        {
          id: comment.id,
          user_id: comment.user_id,
          content: comment.content,
          created_at: comment.created_at.strftime("%d.%m"),
          user_name: comment.user.profile.name
        }
      end
    }
  end

end