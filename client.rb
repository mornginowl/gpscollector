require 'net/http'
require 'uri'
require 'json'
require 'sequel'

uri = URI.parse('http://127.0.0.1:9000/')
http = Net::HTTP.new(uri.host, uri.port)

DB = Sequel.connect('postgres://alex:password@192.168.99.100:5432/gis')
unless DB.table_exists?(:gpspoints)
	DB.create_table :gpspoints do 
			primary_key :id
			column :name, String
	end
	DB.execute("Select AddGeometryColumn('gpspoints','geometry_c',4326,'GEOMETRYCOLLECTION',2);")
	DB.execute("Select AddGeometryColumn('gpspoints','geometry',4326,'POINT',2);")
end

request = Net::HTTP::Post.new(uri.request_uri)
request.body = {name: "POINT",geometry:"POINT(0 0)"}.to_json
request.add_field("Accept", "application/json")
response = http.request(request)
print 'HTTP POST Request to Rack:'
puts response.inspect

request.body = {name: "GEOMETRYCOLLECTION", geometry: "GEOMETRYCOLLECTION( POINT(2 3), LINESTRING(2 3 , 3 4 ) )"}.to_json
request.add_field("Accept", "application/json")
response = http.request(request)
print 'HTTP POST Request to Rack:'
puts response.inspect



#response = Net::HTTP.get_response(uri)
response = Net::HTTP.get(uri)
puts "HTTP GET Request"
puts response.inspect

params = {:x => 102.0,:y =>0.5,:r=>100}
uri.query = URI.encode_www_form(params)
response = Net::HTTP.get_response(uri)
puts "HTTP GET Request"
puts response.inspect