require 'rack'
#app = Rack::Builder.parse_file('rackup.ru')
#mock_request = Rack::MockRequest.new(app)
 mr = Rack::MockRequest.env_for("/","HTTP_HOST" => "127.0.0.1","SERVER_PORT"=>9000,
      "REQUEST_METHOD" => 'POST',
      :input => "name=point&geometry='POINT(0 0)'"
    )
puts 'xxxx'
req = Rack::Request.new mr
puts req.inspect
#response = mock_request.get('')
#expect(response.status).to eq(200)
#expect(response.get_header('Content-Type')).to eq('text/html')
#expect(response.body).to eq('Hello World')
response = req.post?

#expect(response.status).to eq(200)
#expect(response.get_header('Content-Type')).to eq('text/html')
