# README

 # ROUTES
  - POST `api/v1/admins` { parameters: `name`, `email`, `password` } (creates an admin user)
  - POST `api/v1/admins/login` { parameters: `email`, `password` } (logs in user)
  - GET `api/v1/events` (gets all events)
  - GET `api/v1/events/{:event_id}` { gets an event }
  - POST `api/v1/events` { parameters: `name` } (admin must be signed in)
  - GET `api/v1/events/:event_id/attendance` (Gets number of attendees of an event) (access to only admin)
  - GET `api/v1/events/:event_id/sessions` (Gets the sessions of an event)
  - POST `api/v1/events/:event_id/sessions` { parameters: `name`, `max_rsvp` } (creates a seesion for an event, access to only admin)
  - POST `api/v1/sessions/:id/subscribe` { parameters: `user_name`, `email`} (rsvp to an event)
  - PUT `api/v1/user/:id/attend` { none } (marks a user as an attendee)
     