class AddUserIdToAuthors < ActiveRecord::Migration[7.2]
  def change
    add_reference :authors, :user, foreign_key: true 
  end
end
