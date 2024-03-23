class UserSerializer < ActiveModel::Serializer
  attributes :id, :fname, :lname, :email, :last_activity, :display_name, :is_admin, :name, :is_followed,
    :follower_count, :following_count

  def follower_count
    object.followers.count
  end

  def following_count
    object.following.count
  end

  def is_followed
    object.followers.include?(scope)
  end

  def last_activity
    object.actions.last
  end

  # def display_name
  #   "#{object.fname} #{object.lname&.first}"
  # end
end
