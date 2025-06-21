class AddFavoriteThemesToProfiles < ActiveRecord::Migration[7.2]
  def change
    add_column :profiles, :favorite_themes, :string
  end
end