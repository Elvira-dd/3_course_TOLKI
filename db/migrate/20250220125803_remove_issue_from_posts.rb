class RemoveIssueFromPosts < ActiveRecord::Migration[7.2]
  def change
    remove_reference :posts, :issue, foreign_key: true
  end
end
