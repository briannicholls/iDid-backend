# frozen_string_literal: true

require 'yaml'

def seed
  create_default_test_user
  create_default_counters
  load_units_of_measure
end

def create_default_test_user
  User.find_or_create_by!(email: 'fryguy99@krustykrab.com') do |user|
    user.fname = 'Spongebob'
    user.lname = 'Squarepants'
    user.password = 'i<3mrkrabs'
    user.password_confirmation = 'i<3mrkrabs'
    user.confirmed_at = Time.now
  end
end

def create_default_counters
  counters = [
    { name: 'Jumping Jacks', dimension: 'default' },
    { name: 'Meditation', dimension: 'time' },
    { name: 'Dead lift', dimension: 'weight' }
  ]

  counters.each do |counter_attrs|
    puts "Creating counter: #{counter_attrs[:name]}"
    Counter.find_or_create_by(name: counter_attrs[:name]) do |counter|
      counter.dimension = counter_attrs[:dimension]
      counter.track_reps = true if counter_attrs[:dimension] == 'default'
    end
  end
end

def load_units_of_measure
  units = YAML.load_file(Rails.root.join('db', 'units_of_measure.yml'))
  units.each do |unit_attrs|
    puts "Creating unit: #{unit_attrs['name']} (#{unit_attrs['abbreviation']}) for #{unit_attrs['dimension']}"

    unit = UnitOfMeasure.find_or_initialize_by(name: unit_attrs['name'], abbreviation: unit_attrs['abbreviation'],
                                               dimension: unit_attrs['dimension'])

    # Assign attributes regardless of whether it's a new record or existing one
    unit.assign_attributes(unit_attrs)

    # Save or update the record
    unit.save!
  end
end

seed
