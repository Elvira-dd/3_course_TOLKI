class CreatePlaylists < ActiveRecord::Migration[7.2]
  def change
    create_table :playlists do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
