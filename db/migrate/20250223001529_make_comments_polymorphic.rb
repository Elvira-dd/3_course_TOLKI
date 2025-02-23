class MakeCommentsPolymorphic < ActiveRecord::Migration[7.2]
  def change
    remove_reference :comments, :post, foreign_key: true

    add_reference :comments, :commentable, polymorphic: true
  end
end
