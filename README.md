# Meetr

A Ruby on Rails app to find a meeting place that's at the centre of all the starting addresses provided.

## Models

### User
* first_name
* last_name
* email
* password

### Meeting
* title
* midpoint_latitude
* midpoint_longitude
* date_time

### User_Meeting (Join Table)
* user_id  (validation for unique)
* meeting_id   (validation for unique)
* start_latitude
* start_longitude
* user_status (created | invited | confirmed | declined)
* start_address

### Venue   
* name
* address
* category 

### Meeting_Venue (Join Table)
* meeting_id
* venue_id
* selected ---- boolean
