class CreateDislikes < ActiveRecord::Migration[7.2]
  def change
    create_table :dislikes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :dislikeable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
