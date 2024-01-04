class UserSerializer < ActiveModel::Serializer
  attributes :id, :fname, :lname, :email, :last_activity

  def last_activity
    object.actions.last
  end
end
