class UserSerializer < ActiveModel::Serializer
  attributes :id, :fname, :lname, :email, :last_activity, :display_name, :is_admin, :name

  def last_activity
    object.actions.last
  end

  # def display_name
  #   "#{object.fname} #{object.lname&.first}"
  # end
end
