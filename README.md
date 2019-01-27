# Meetr

A Ruby on Rails app to help groups decide on a central location to meet at when people in the group are coming from different start locations. Once the app figures out the mid-point, it also suggests venues that people can meet at.


### Models
### Rails API
### 3rd Party API details
### Algorithms
### User Journeys
### Screenshots
-------------------------
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

## Rails Routes

| Helper  	|  HTTP Verb 	| Path  	|  Controller#Action 	|
|---	|---	|---	|---	|
|  meeting_venues_path 	|  GET 	| /meeting_venues(.:format)	  	| meeting_venues#index  	|
|   	| POST  	|  /meeting_venues(.:format)	 	| meeting_venues#create  	|
| new_meeting_venue_path  	| GET  	| /meeting_venues/new(.:format)	  	| meeting_venues#new  	|
|  edit_meeting_venue_path 	|  GET 	| /meeting_venues/:id/edit(.:format)	  	|  meeting_venues#edit 	|
|  meeting_venue_path 	| GET  	| /meeting_venues/:id(.:format)  	|  meeting_venues#show 	|
|   	| PATCH  	| /meeting_venues/:id(.:format)	  	|  meeting_venues#update 	|
|   	| PUT  	| /meeting_venues/:id(.:format)	  	|  meeting_venues#update 	|
|   	|  DELETE 	| /meeting_venues/:id(.:format)  	|  meeting_venues#destroy 	|
|  venues_path 	|  GET 	| /venues(.:format)	  	| venues#index  	|
|   	| POST  	|  /venues(.:format)	 	| venues#create  	|
| new_venue_path  	| GET  	| /venues/new(.:format)	  	| venues#new  	|
|  edit_venue_path 	|  GET 	| /venues/:id/edit(.:format)	  	|  venues#edit 	|
|  venue_path 	| GET  	| /venues/:id(.:format)  	|  venues#show 	|
|   	| PATCH  	| /venues/:id(.:format)	  	|  venues#update 	|
|   	| PUT  	| /venues/:id(.:format)	  	|  venues#update 	|
|   	|  DELETE 	| /venues/:id(.:format)  	|  venues#destroy 	|
|  user_meetings_path 	|  GET 	| /user_meetings(.:format)	  	| user_meetings#index  	|
|   	| POST  	|  /user_meetings(.:format)	 	| user_meetings#create  	|
| new_user_meeting_path  	| GET  	| /user_meetings/new(.:format)	  	| user_meetings#new  	|
|  edit_user_meeting_path 	|  GET 	| /user_meetings/:id/edit(.:format)	  	|  user_meetings#edit 	|
|  user_meeting_path 	| GET  	| /user_meetings/:id(.:format)  	|  user_meetings#show 	|
|   	| PATCH  	| /user_meetings/:id(.:format)	  	|  user_meetings#update 	|
|   	| PUT  	| /user_meetings/:id(.:format)	  	|  user_meetings#update 	|
|   	|  DELETE 	| /user_meetings/:id(.:format)  	|  user_meetings#destroy 	|
|  meetings_path 	|  GET 	| /meetings(.:format)	  	| meetings#index  	|
|   	| POST  	|  /meetings(.:format)	 	| meetings#create  	|
| new_meeting_path  	| GET  	| /meetings/new(.:format)	  	| meetings#new  	|
|  edit_meeting_path 	|  GET 	| /meetings/:id/edit(.:format)	  	|  meetings#edit 	|
|  meeting_path 	| GET  	| /meetings/:id(.:format)  	|  meetings#show 	|
|   	| PATCH  	| /meetings/:id(.:format)	  	|  meetings#update 	|
|   	| PUT  	| /meetings/:id(.:format)	  	|  meetings#update 	|
|   	|  DELETE 	| /meetings/:id(.:format)  	|  meetings#destroy 	|
|  users_path 	|  GET 	| /users(.:format)	  	| users#index  	|
|   	| POST  	|  /users(.:format)	 	| users#create  	|
| new_user_path  	| GET  	| /users/new(.:format)	  	| users#new  	|
|  edit_user_path 	|  GET 	| /users/:id/edit(.:format)	  	|  users#edit 	|
|  user_path 	| GET  	| /users/:id(.:format)  	|  users#show 	|
|   	| PATCH  	| /users/:id(.:format)	  	|  users#update 	|
|   	| PUT  	| /users/:id(.:format)	  	|  users#update 	|
|   	|  DELETE 	| /users/:id(.:format)  	|  users#destroy 	|
|  root_path 	|  GET 	|  / 	|  users#new 	|
|  login_path 	|  GET 	| /login(.:format)  	| sessions#new  	|
|  sessions_path 	|  POST 	| /sessions(.:format)  	|  sessions#create 	|
|  logout_path 	|  POST 	|  	/logout(.:format)	 	|  sessions#destroy 	|


## 3rd Party API Details
Signed up for the HERE API: https://developer.here.com/


### API to search for lat long from user entered address or postcode:
```
https://geocoder.api.here.com/6.2/geocode.json?app_id=API_ID&app_code=APP_CODE&searchtext=USERINPUTHERE
```

API needs:
 `searchtext=USERINPUTHERE` 

### API to get address from lat, long:
```
https://reverse.geocoder.api.here.com/6.2/reversegeocode.json?app_id=API_ID&app_code=APP_CODE&mode=retrieveAddresses&prox=51.50463,-0.17189
```

`retrieveAddresses&prox=51.50463,-0.17189` - enter lat, long here

### API to search for places to eat or drink around there:
```
https://geocoder.api.here.com/6.2/geocode.json?app_id=API_ID&app_code=APP_CODE&searchtext=ec2a1NT
```

### API needs:
 `cat=eat-drink` 
`at=51.5162,-0.0864;r=100`
(positive number is latitude, negative is longitude, *r* is radius)
