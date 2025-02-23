class CreateJoinTableAuthorsPodcasts < ActiveRecord::Migration[7.2]
  def change
    create_join_table :authors, :podcasts do |t|
       t.index [:author_id, :podcast_id]
       t.index [:podcast_id, :author_id]
    end
  end
end
