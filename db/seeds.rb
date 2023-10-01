# frozen_string_literal: true
def seed
  create_default_test_user
  create_default_counters
end

def create_default_test_user
  User.create(
    fname: 'Spongebob',
    lname: 'Squarepants',
    password: 'i<3mrkrabs',
    password_confirmation: 'i<3mrkrabs',
    email: 'fryguy99@krustykrab.com',
    confirmed_at: Time.now
  )
end

def create_default_counters
  Counter.create(
    name: 'Jumping Jacks',
    kind: 'default'
  )
  Counter.create(
    name: 'Meditation',
    kind: 'timed'
  )
  Counter.create(
    name: 'Dead lift',
    kind: 'weighted'
  )
end

seed
