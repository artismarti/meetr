# Meetr

A Ruby on Rails app to help groups decide on a central location to meet at when people in the group are coming from different start locations. Once the app figures out the mid-point, it also suggests venues that people can meet at.


### Models
### API details
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

## API Details
Signed up for the HERE API: https://developer.here.com/


## API to search for lat long from user entered address or postcode:
```
https://geocoder.api.here.com/6.2/geocode.json?app_id=API_ID&app_code=APP_CODE&searchtext=USERINPUTHERE
```

API needs:
 `searchtext=USERINPUTHERE` 

## API to get address from lat, long:
```
https://reverse.geocoder.api.here.com/6.2/reversegeocode.json?app_id=API_ID&app_code=APP_CODE&mode=retrieveAddresses&prox=51.50463,-0.17189
```

`retrieveAddresses&prox=51.50463,-0.17189` - enter lat, long here

## API to search for places to eat or drink around there:
```
https://geocoder.api.here.com/6.2/geocode.json?app_id=API_ID&app_code=APP_CODE&searchtext=ec2a1NT
```

API needs:
 `cat=eat-drink` 
`at=51.5162,-0.0864;r=100`
(positive number is latitude, negative is longitude, *r* is radius)
