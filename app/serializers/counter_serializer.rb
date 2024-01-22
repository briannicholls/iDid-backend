class CounterSerializer < ActiveModel::Serializer
  attributes :id, :name, :dimension, :track_reps, :created_by, :name_singular, :name_plural, :recent_doers

  def recent_doers
    # Get distinct user_ids from the most recent actions
    user_ids = object.actions.select(:user_id).distinct.limit(5).pluck(:user_id)
  
    # Fetch the users corresponding to these ids
    # use user serializer
    # User.where(id: user_ids)
    ActiveModelSerializers::SerializableResource.new(User.where(id: user_ids), each_serializer: UserSerializer)
  end
  

end
