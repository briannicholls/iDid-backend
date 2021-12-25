class Counter < ApplicationRecord
  # include ActiveModel::Serialization

  has_many :actions

  validates :name, presence: true, uniqueness: true
  validates_inclusion_of :kind, in: ['default', 'weighted', 'timed']

  # returns user with most reps for this counter
  def leader(datetime)
    # filter actions in this time range
    actions_in_range = self.actions.since(datetime)

    # get unique users having actions for this counter
    unique_users = actions_in_range.pluck(:user_id).uniq

    leader = ''
    # for each unique user having performed actions in this time range for this counter
    result = unique_users.inject(0){ |memo, user_id|
      # get those actions
      acs = actions_in_range.where('user_id = ?', user_id)
      # sum the reps
      reps = acs.sum(:reps)

      if reps > memo
        leader = User.find_by(id: user_id).name
        reps
      else
        memo
      end
    }
    {counter_name: self.name, name: leader, reps: result}
  end

  def self.leaders(datetime)
    Counter.all.map{ |counter|
      counter.leader(datetime)
    }
  end

end
