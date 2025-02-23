class AddExtenBioToAuthors < ActiveRecord::Migration[7.2]
  def change
    add_column :authors, :exten_bio, :string
  end
end
