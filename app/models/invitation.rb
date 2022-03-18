class Invitation < ApplicationRecord
  belongs_to :user
  # has_many :friends, class_name: :User, through: :invitations, foreign_key: :friend_id
end
