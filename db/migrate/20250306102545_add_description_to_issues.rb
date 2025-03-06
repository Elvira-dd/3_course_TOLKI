class AddDescriptionToIssues < ActiveRecord::Migration[7.2]
  def change
    add_column :issues, :description, :text
  end
end
