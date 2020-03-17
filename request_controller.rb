require 'sequel'
db = Sequel.connect('postgres://alex:password@192.168.99.100:5432/gis')
class Gpspoints < Sequel::Model
	def initialize()
	end
	def isave(params)
		#db = Sequel.connect('postgres://alex:password@192.168.99.100:5432/gis')
		if params['name'].downcase == "point".downcase
			out = "INSERT INTO gpspoints(name,geometry) VALUES('#{params['name']}',ST_GeomFromText('#{params['geometry']}',4326))"
		elsif params['name'].downcase == "geometrycollection".downcase
			out = "INSERT INTO gpspoints(name,geometry_c) VALUES('#{params['name']}',ST_GeomFromText('#{params['geometry']}',4326))"
		end 

		insert_ds = db[out]
		insert_ds.insert
	end 
	def allpoints
		"select id,name,ST_AsGeoJSON(geometry),ST_AsText(geometry_c) from gpspoints"
	end
	def radius(params="")
		h = Rack::Utils.parse_nested_query params
		"select id,name,ST_AsGeoJSON(geometry),ST_AsText(geometry_c) from gpspoints where ST_DWithin(geometry,ST_MakePoint(#{h['x']},#{h['y']})::geography,#{h['r']})"
	end
	def gpspoints(pdata = "")
		db = Sequel.connect('postgres://alex:password@192.168.99.100:5432/gis')
		sql = pdata.empty? ? allpoints : radius(pdata)
		select_db = db[sql]
		gpspoints = select_db.select
		gpspoints.all{|row| p row}.to_json
	end
end
class RequestController

	def loadPost(params)
	  	gps = Gpspoints.new
		puts params.inspect
		gps.isave params
	end
	def loadPoints(pdata)
		gps = Gpspoints.new
		gps.gpspoints(pdata)
	#	out = pdata.empty? ? gps.gpsstore : gps.radius(pdata)
	end

  	def call(env)
	  	r = Rack::Request.new(env)
	  	case r.request_method
		  	when 'POST'
		  		begin 
					loadPost JSON.parse env['rack.input'].read
					[200,{"Content-Type"=>"text/plain"},["GEOJson Object Added"]]
				end
		  	
		  	when 'GET'
		  		begin 
					loadPoints env['QUERY_STRING'] 
		   			[200, {"Content-Type" => "text/plain"}, ["OK" ]]
		   		end
		end
    end
end