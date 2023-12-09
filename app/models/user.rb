class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # , :confirmable
  # include ActiveModel::Serialization

  has_many :actions, dependent: :destroy

  has_many :invitations, dependent: :destroy
  has_many :friends, class_name: :User, through: :invitations, foreign_key: :friend_id

  validates :email, uniqueness: true, presence: true
  validates :fname, presence: true
  validates :lname, presence: true

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
    "#{fname} #{lname.chars[0]}"
  end

  def encode_jwt
    JWT.encode({ user_id: id, email: }, Rails.application.secrets.secret_key_base)
  end
end
