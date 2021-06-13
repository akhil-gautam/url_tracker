require 'sinatra'
require 'httparty'
require "sinatra/namespace"
require 'pry'

require_relative './lib/harper_orm'
require_relative './lib/utils'

Dir["./models/*.rb"].each {|file| load file }
Dir["./controllers/*.rb"].each {|file| load file }

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

end
