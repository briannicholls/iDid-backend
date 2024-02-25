class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # , :confirmable

  has_many :actions, dependent: :destroy

  # Relationships where this user is the follower
  has_many :followed_users, foreign_key: :follower_id, class_name: 'Follow'
  has_many :following, through: :followed_users, source: :followed

  # Relationships where this user is being followed
  has_many :follower_users, foreign_key: :following_id, class_name: 'Follow'
  has_many :followers, through: :follower_users, source: :follower

  validates :email, uniqueness: true, presence: true
  validates :fname, presence: true
  validates :lname, presence: true

  # Get recent actions from followed users
  def feed
    followed_user_ids = "SELECT following_id FROM follows WHERE follower_id = :user_id"
    Action.where("user_id IN (#{followed_user_ids})", user_id: id)
          .includes(:user) # Optional, to reduce N+1 queries
          .order(created_at: :desc)
  end

  def self.leaders_since(datetime)
    # get unique counters for this time frame
    actions = Action.since(datetime)
    unique_counters = actions.pluck(:counter).uniq

    # map unique counters to leader hash
    unique_counters.map do |counter|
      { counter:, leader: counter.leader(datetime) }
    end

    # returns array of hashes
  end

  def counter_actions(counter_id)
    actions.where('counter_id = ?', counter_id)
  end

  def name
    "#{fname} #{lname&.chars&.first}"
  end

  def display_name
    name
  end

  def encode_jwt
    JWT.encode({ user_id: id, email: }, Rails.application.secrets.secret_key_base)
  end
end
