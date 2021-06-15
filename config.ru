require './api'
require 'rack/contrib'

use Rack::PostBodyContentTypeParser
run Sinatra::Application