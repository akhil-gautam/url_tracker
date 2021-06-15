require 'sinatra'
require 'httparty'
require "sinatra/namespace"
require 'pry'

require_relative './lib/harper_orm'
require_relative './lib/utils'

Dir["./models/*.rb"].each {|file| load file }
Dir["./controllers/*.rb"].each {|file| load file }

configure do
  enable :cross_origin
end
before do
  response.headers['Access-Control-Allow-Origin'] = '*'
end

# routes...
options "*" do
  response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
  response.headers["Access-Control-Allow-Origin"] = "*"
  200
end

get '/:id' do
  link = LinkHitsController.create(params.merge({ ip: request.ip }))
  redirect link
rescue Exception => e
  redirect request.base_url
end

namespace '/api/v1' do
  before do
    content_type 'application/json'
  end

  post '/users' do
    UsersController.create(params).to_json
  rescue Exception => e
    halt 422, { message: e.message}.to_json
  end

  post '/login' do
    UsersController.login(params).to_json
  rescue Exception => e
    halt 422, { message: e.message}.to_json
  end

  get '/users/:id/links' do
    LinksController.index(params).to_json
  rescue Exception => e
    halt 422, { message: e.message }.to_json
  end

  post '/links' do
    if params[:token].length == 24 && User.exists?({ token: params[:token]})
      result = LinksController.create(params)
      { url: request.base_url + '/' + result }.to_json
    else
      halt 401, { message: "Can't find the user."}.to_json
    end
  rescue Exception => e
    halt 422, { message: e.message }.to_json
  end

  patch '/links/:id ' do
    if params[:token].length == 24 && User.exists?({ token: params[:token]})
      result = LinksController.update(params)
      { message: "Updated successfuly."}.to_json
    else
      halt 401, { message: "Can't find the user."}.to_json
    end
  rescue Exception => e
    halt 422, { message: e.message }.to_json
  end

  get '/links/:id/hits' do
    LinkHitsController.index(params).to_json
  rescue Exception => e
    halt 422, { message: e.message }.to_json
  end

end
