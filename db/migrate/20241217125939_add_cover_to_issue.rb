class AddCoverToIssue < ActiveRecord::Migration[7.2]
  def change
    add_column :issues, :cover, :text
  end
end
