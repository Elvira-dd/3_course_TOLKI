class RemoveIsCommentsOpenAndLinkFromPosts < ActiveRecord::Migration[7.2]
  def change
    remove_column :posts, :is_comments_open, :boolean
    remove_column :posts, :link, :string
  end
end
