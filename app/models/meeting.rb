class Meeting < ApplicationRecord
  has_many :user_meetings
  has_many :users, through: :user_meetings
  validates :date_time, presence: true
  validates :title, presence: true

  def get_address(lat,lng)
    url = "https://reverse.geocoder.api.here.com/6.2/reversegeocode.json?app_id=EUNJEIDbEAKKaUz5IRBj&app_code=nI-30KLhGkA-zFavU7hhYw&mode=retrieveAddresses&prox=#{lat},#{lng}"
    response_string = RestClient.get(url)
    response_hash = JSON.parse(response_string)
    meeting_address = response_hash["Response"]["View"][0]["Result"][0]["Location"]["Address"]["Label"]
  end

  def get_lat_lng_hash
    @user_meetings = self.user_meetings
    lat_lng = {}
    lats = @user_meetings.map{|um| um.start_latitude}
    lat_lng[:lat] = lats
    lngs = @user_meetings.map{|um| um.start_longitude}
    lat_lng[:lng] = lngs
    lat_lng
  end
  def recalculate_midpoint
    self.get_midpoint_lat(self.get_lat_lng_hash)
    self.get_midpoint_lng(self.get_lat_lng_hash)
    self.save
  end

  def get_midpoint_lat(get_lat_lng_hash)
    if radian_lat(get_lat_lng_hash)
      self.update(midpoint_latitude: radian_lat(get_lat_lng_hash))
    else
      self.update(midpoint_latitude: 1.11111)
    end
  end

  def get_midpoint_lng(get_lat_lng_hash)
    if radian_lng(get_lat_lng_hash)
      self.update(midpoint_longitude: radian_lng(get_lat_lng_hash))
    else
      self.update(midpoint_longitude: -0.33333)
    end
  end

  # Convert lat/long from hash to cartesian (x,y,z) coordinates
  def cosify_hash(l_hash)
    # create empty hash with the following keys:
    cos_hash = Hash.new
    cos_hash[:cos_lat] = []
    cos_hash[:cos_lng] = []
    cos_hash[:product] = []

    # convert each latitude from l_hash into degrees (lat*PI/180)
    # calculate the cos of the degree value & push it into the hash
    # as the value for key :cos_lat
    l_hash[:lat].each do |lat|
       cos_hash[:cos_lat] << (cos(lat * PI/180))
    end
    # convert each longitude from l_hash into degrees (lng*PI/180)
    # calculate the cos of the degree value & push it into the hash
    # as the value for key :cos_lng
    l_hash[:lng].each do |lng|
       cos_hash[:cos_lng] << (cos(lng * PI/180))
    end

    # multiply the cosified degree lat with the cosified degree lng
    # push it as values for the :product key
    cos_hash[:product] = cos_hash[:cos_lat].zip(cos_hash[:cos_lng]).map{|lat,lng| (lat*lng)}
    # add all the values in the product key
    cos_hash[:product].reduce(0){|sum, num| sum+num}
  end

  def cos_sinify(l_hash)
    # create empty hash with the following keys:
    cos_sin_hash = Hash.new
    cos_sin_hash[:cos_lat] = []
    cos_sin_hash[:sin_lng] = []
    cos_sin_hash[:product] = []

    # convert each latitude from l_hash into degrees (lat*PI/180)
    # calculate the cos of the degree value & push it into the hash
    # as the value for key :cos_lat
    l_hash[:lat].each do |lat|
       cos_sin_hash[:cos_lat] << (cos(lat * PI/180))
    end

    # convert each longitude from l_hash into degrees (lat*PI/180)
    # calculate the sin of the degree value & push it into the hash
    # as the value for key :sin_lng
    l_hash[:lng].each do |lng|
       cos_sin_hash[:sin_lng] << (sin(lng * PI/180))
    end
    # zip the lats & lngs
    # multiply the cosified degree lat with the sinified degree lng
    # push them as values for the :product key
    cos_sin_hash[:product] = cos_sin_hash[:cos_lat].zip(cos_sin_hash[:sin_lng]).map{|lat,lng| (lat*lng)}
    # sum all the values in the product key
    cos_sin_hash[:product].reduce(0){|sum, num| sum+num}
  end

  def sinify(l_hash)
    sin_hash = Hash.new
    sin_hash[:sin_lat] = []
    l_hash[:lat].each do |lat|
       sin_hash[:sin_lat] << (sin(lat * PI/180))
    end
    sin_hash[:sin_lat].reduce(0){|sum, num| sum+num}
  end

  # Compute combined weighted cartesian coordinates
  # Convert cartesian coordinate to latitude and longitude for the midpoint
  def radian_calcs(l_hash)
    cosify_hash(l_hash)
    cos_sinify(l_hash)
    sinify(l_hash)
    total_locations = l_hash[:lat].count #3 cities
    x = (cosify_hash(l_hash)/total_locations)
    y = (cos_sinify(l_hash)/total_locations)
    z = (sinify(l_hash)/total_locations)
    hyp = sqrt((x*x)+(y*y))
    [x, y, z, hyp]
  end

  # Convert midpoint lat and lon from radians to degrees
  def radian_lat(l_hash)
    x, y, z, hyp = radian_calcs(l_hash)
    (atan2(z,hyp) * (180/PI)).round(5)
  end

  def radian_lng(l_hash)
    x, y, z, hyp = radian_calcs(l_hash)
   (atan2(y,x) * (180/PI)).round(5)
  end



end
