# iDid API

Backend API for my [React application](https://linktr.ee/idid_app).
[React Native Repo here](https://github.com/nichol88/iDid-frontend) (private for the foreseeable future) 

## Models

### Counters

`Counter`s are the things that you can count, for example, Burger Flips, Deadlifts, or Meditation.

For timed activities such as meditation, the Counter will need `dimension: 'time'`.
For weightlifting activities, the Counter may have `dimension: 'weight'`.
Otherwise, `dimension` will be `'default'`.

### Actions

An `Action` is an instance of a user performing an activity. It ties the `Counter` to the `User`, along with the number of reps (or minutes/seconds for a timed activity), and the weight (for a weightlifting activity).


## Routes

### Public

`/counters` - lists all the user-created counters that are able to be counted

### Private

`/users/:id/actions` - lists all action entries for given user

## Development

Add the following environment variables. View `./sample.env` for examples.
`NGROK_HTTP_HOST`
`DATABASE_USERNAME`
`DATABASE_PASSWORD`
`SENDGRID_DEVELOPMENT_KEY`

Run `rails s -p 3000` to start the app on port 3000.

## Production
Set the following using `rails credentials:edit`:

```bash
sendgrid_production_key: your_key_for_production
```
