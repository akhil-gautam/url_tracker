# frozen_string_literal: true

require './api'
require 'rack/contrib'

use Rack::JSONBodyParser
run Sinatra::Application
