require 'rack'
load 'request_controller.rb'

Rack::Handler::WEBrick.run(
  RequestController.new,
  :Port => 9000
)