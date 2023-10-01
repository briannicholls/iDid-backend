class Counter < ApplicationRecord
  has_many :actions
  has_many :counter_units
  has_many :units_of_measure, through: :counter_units

  validates :name, presence: true, uniqueness: true
  validates_inclusion_of :kind, in: ['default', 'weighted', 'timed']

  # returns user with most reps for this counter since datetime
  def leader(datetime)
    # filter actions in this time range
    actions_in_range = self.actions.since(datetime)

    # get unique users having actions for this counter
    unique_users = actions_in_range.pluck(:user_id).uniq

    leader = nil
    
    # for each unique user having performed actions in this time range for this counter
    reps = unique_users.inject(0){ |memo, user_id|
      # get those actions
      acs = actions_in_range.where('user_id = ?', user_id)
      # sum the reps
      reps = acs.sum(:reps)

      if reps > memo
        leader = User.find_by(id: user_id)
        reps
      else
        memo
      end
    }
    if leader
      { counter_name: self.name, name: leader.name, reps: reps, user_id: leader.id }
    else
      {}
    end
  end

  # returns leaders since datetime
  def self.leaders(datetime)
    Counter.all.map{ |counter|
      counter.leader(datetime)
    }
  end

end
