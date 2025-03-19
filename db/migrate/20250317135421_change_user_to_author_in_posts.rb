class ChangeUserToAuthorInPosts < ActiveRecord::Migration[7.2]
  def change
    remove_column :posts, :user_id, :integer
    add_reference :posts, :author, foreign_key: { to_table: :authors }, index: true
  end
end
