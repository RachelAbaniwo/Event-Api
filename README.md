# README

 # ROUTES
  - POST `api/v1/admins` { parameters: `name`, `email`, `password` } (creates an admin user)
  - POST `/admins/login` { parameters: `email`, `password` } (logs in user)
  - GET `api/vi/events` (gets all events)
  - GET `api/vi/events/{:event_id}` { gets an event }
  - POST `api/vi/events` { parameters: `name` } (admin must be signed in)
  - GET `/events/:event_id/attendance` (Gets number of attendees of an event) (access to only admin)
  - GET `/events/:event_id/sessions` (Gets the sessions of an event)
  - POST `/events/:event_id/sessions` { parameters: `name`, `max_rsvp` } (creates a seesion for an event, access to only admin)
  - POST `sessions/:id/subscribe` { parameters: `user_name`, `email`} (rsvp to an event)
  - PUT `user/:id/attend` { none } (marks a user as an attendee)
     