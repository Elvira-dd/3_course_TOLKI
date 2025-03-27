class AddCoverToIssues < ActiveRecord::Migration[6.0]
  def change
    remove_column :issues, :cover, :text  # Удаляем старое поле cover
    add_column :issues, :cover, :string   # Создаем новое поле для ActiveStorage
  end
end