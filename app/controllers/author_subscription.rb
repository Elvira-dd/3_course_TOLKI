class AuthorSubscription < ApplicationRecord
  belongs_to :user
  belongs_to :author
end