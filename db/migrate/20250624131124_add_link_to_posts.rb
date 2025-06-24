class AddLinkToPosts < ActiveRecord::Migration[7.2]
  def change
    add_column :posts, :link, :string
  end
end
