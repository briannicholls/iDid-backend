# iDid API

Backend API for my React application found here: https://github.com/nichol88/iDid-frontend

## Models

### Counters

`Counter`s are the things that you can count, for example, Burger Flips, Deadlifts, or Meditation.

For timed activities such as meditation, the Counter will need `kind: 'timed'`.
For weightlifting activities, the Counter may have `kind: 'weighted'`.
Otherwise, `kind` will be `'default'`.
If `Counter.kind` is not `'default'`, you will need to specify `Counter.measurement_unit` according to the `kind`, i.e. "seconds" for a timed activity or "kilograms" for a weighted activity.

### Actions

An `Action` is an instance of a user performing an activity. It ties the `Counter` to the `User`, along with the number of reps (or minutes/seconds for a timed activity), and the weight (for a weightlifting activity).

# Installation

Download the repo, then run `rails s` to initialize the server. Default port is 3001.

# Routes

## Public

`/counters` - lists all the user-created counters that are able to be counted

## Private

`/users/:id/actions` - lists all action entries for given user
