require './api'
require 'rack/contrib'

use Rack::JSONBodyParser
run Sinatra::Application