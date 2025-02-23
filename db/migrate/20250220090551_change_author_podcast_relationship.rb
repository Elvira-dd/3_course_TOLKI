class ChangeAuthorPodcastRelationship < ActiveRecord::Migration[7.2]
  def change
    drop_table :authors_podcasts, if_exists: true

    add_reference :podcasts, :author, foreign_key: true
  end
end
