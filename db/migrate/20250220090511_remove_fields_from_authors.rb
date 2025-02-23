class RemoveFieldsFromAuthors < ActiveRecord::Migration[7.2]
  def change
    remove_column :authors, :name, :text
    remove_column :authors, :description, :text
    remove_column :authors, :avatar, :text
  end
end
