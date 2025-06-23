class CreateAuthorSubscriptions < ActiveRecord::Migration[7.2]
  def change
    create_table :author_subscriptions do |t|
      t.integer :user_id, null: false
      t.integer :author_id, null: false

      t.timestamps
    end

    add_index :author_subscriptions, [:user_id, :author_id], unique: true
    add_foreign_key :author_subscriptions, :users
    add_foreign_key :author_subscriptions, :authors
  end
end