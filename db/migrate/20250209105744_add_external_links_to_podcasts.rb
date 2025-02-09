class AddExternalLinksToPodcasts < ActiveRecord::Migration[7.2]
  def change
    add_column :podcasts, :external_links, :json
  end
end
