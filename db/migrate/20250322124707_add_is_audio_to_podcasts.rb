class AddIsAudioToPodcasts < ActiveRecord::Migration[7.2]
  def change
    add_column :podcasts, :is_audio, :boolean
  end
end
