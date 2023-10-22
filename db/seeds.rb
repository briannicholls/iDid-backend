# frozen_string_literal: true

def seed
  create_default_test_user
  create_default_counters
  create_default_measurement_units
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
    dimension: 'default'
  )
  Counter.create(
    name: 'Meditation',
    dimension: 'time'
  )
  Counter.create(
    name: 'Dead lift',
    dimension: 'weight'
  )
end

def create_default_measurement_units
  units = [
    { name: 'Pounds',  abbreviation: 'lbs', dimension: 'weight', system: 'us_standard' },
    { name: 'Minutes', abbreviation: 'min', dimension: 'time' },
    { name: 'Miles',   abbreviation: 'mi',  dimension: 'distance' },
    { name: 'Kilograms', abbreviation: 'kg', dimension: 'weight', system: 'metric' },
    { name: 'Seconds', abbreviation: 'sec', dimension: 'time' },
    { name: 'Kilometers', abbreviation: 'km', dimension: 'distance' }
  ]
  units.each { |unit| UnitOfMeasure.create(unit) }
end

seed
