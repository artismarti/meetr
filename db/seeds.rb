User.destroy_all
Meeting.destroy_all
UserMeeting.destroy_all


20.times do
  User.create!(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, password: Faker::Internet.password)
end
10.times do
  Meeting.create!(title: Faker::Nation.capital_city, date_time: Faker::Time.between(DateTime.now + 1, DateTime.now+20))
end

UserMeeting.create(user_id: 1, meeting_id: 1, start_latitude: 51.53289 , start_longitude: -0.13096 ,user_status: "created", start_address: Faker::Address.postcode )
UserMeeting.create(user_id: 8, meeting_id: 1, start_latitude: 51.48881 , start_longitude: -0.22293 ,user_status: "invited")
UserMeeting.create(user_id: 9, meeting_id: 1, start_latitude: 51.52612 , start_longitude: -0.10722 ,user_status: "declined")

UserMeeting.create(user_id: 2, meeting_id: 2, start_latitude: 51.53289 , start_longitude: -0.13096 ,user_status: "created", start_address: Faker::Address.postcode  )
UserMeeting.create(user_id: 4, meeting_id: 2, start_latitude: 51.48881 , start_longitude: -0.22293 ,user_status: "invited")
UserMeeting.create(user_id: 5, meeting_id: 2, start_latitude: 51.48881 , start_longitude: -0.22693 ,user_status: "invited")
UserMeeting.create(user_id: 11, meeting_id: 2, start_latitude: 51.52612 , start_longitude: -0.10722 ,user_status: "invited")

UserMeeting.create(user_id: 11, meeting_id: 4, start_latitude: 51.53289 , start_longitude: -0.13096 ,user_status: "created", start_address: Faker::Address.postcode )
UserMeeting.create(user_id: 18, meeting_id: 4, start_latitude: 51.48881 , start_longitude: -0.22293 ,user_status: "invited")
UserMeeting.create(user_id: 19, meeting_id: 4, start_latitude: 51.52612 , start_longitude: -0.10722 ,user_status: "declined")
