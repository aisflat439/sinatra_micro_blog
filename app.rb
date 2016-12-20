require 'sinatra'
require 'sinatra/activerecord'
require './models'

set :database, "sqlite3:test.sqlite3"

get '/' do
  "hello world"
  erb :home
end

get '/users' do
  @user = User.all
  erb :users
end

get '/users/new' do
  erb :signup
end

post '/users/create' do
  user = User.create(params)
  redirect "/users/#{user.id}"
end

get '/users/:id' do
  @user = User.find(params["id"])
  erb :"user_details"
end

get '/posts/new' do
  erb :new_post
end

post '/posts/create' do
  redirect "/"
end
