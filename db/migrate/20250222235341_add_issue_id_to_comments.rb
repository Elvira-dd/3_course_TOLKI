class AddIssueIdToComments < ActiveRecord::Migration[7.2]
  def change
    add_column :comments, :issue_id, :integer
  end
end
