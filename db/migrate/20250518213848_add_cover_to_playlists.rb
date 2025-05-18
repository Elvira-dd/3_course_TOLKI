class AddCoverToPlaylists < ActiveRecord::Migration[7.2]
  def change
    add_column :playlists, :cover, :string
  end
end
