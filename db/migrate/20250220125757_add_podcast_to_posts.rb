class AddPodcastToPosts < ActiveRecord::Migration[7.2]
  def change
    add_reference :posts, :podcast, foreign_key: true
  end
end
