require 'sinatra'
require 'json'
require 'hobos'

require_relative 'lobsters'

api = Lobsters::Api.new
hobo_api = Hobos::Api.new

set :server, 'webrick'

get '/' do
  { hobos: Array.new(rand(100)) { hobo_api.hobo } }.to_json
end

get '/hobo' do
  { hobo: hobo_api.hobo.to_s }.to_json
end

get '/recent/:page' do
  if params['page'] != '1'
    api.recent(params['page'])
  else
    api.recent
  end
end

get '/frontpage/:page' do
  api.frontpage2(params['page'])
end

post '/search' do
  begin
    data = JSON.parse(request.body.read)
    if data['what'] || data['relevence']
      api.search(data['terms'], data['page'], data['what'])
    else
      api.search(data['terms'], data['page'])
    end
  rescue
    status 400
    body 'invalid JSON format'
  end
end

post '/sign_in' do
  begin
    data = JSON.parse(request.body.read)
    if data['email'] && data['password']
      api.sign_in(data['email'], data['password'])
    end
  rescue
    status 400
    body 'invalid JSON format, please post with email and password values'
  end
end
