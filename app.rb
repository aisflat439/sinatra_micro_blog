require 'sinatra'
require 'sinatra/activerecord'
require './models'

set :database, "sqlite3:test.sqlite3"

get '/' do
  "hello world"
end

get '/users' do
  @user = User.all
  erb :users
end
