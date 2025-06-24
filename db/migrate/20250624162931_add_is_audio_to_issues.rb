class AddIsAudioToIssues < ActiveRecord::Migration[7.2]
  def change
    add_column :issues, :is_audio, :boolean
  end
end
