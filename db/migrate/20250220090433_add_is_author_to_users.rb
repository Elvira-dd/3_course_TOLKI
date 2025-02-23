class AddIsAuthorToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :is_author, :boolean, default: false
  end
end
