require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'sinatra/flash'

set :database, "sqlite3:test.sqlite3"
enable :sessions

@logged_in = false

def verify_login
  if !@logged_in
    if session[:user_id]
      @logged_in = true
      @verify_login = User.find(session[:user_id])
    else
      flash[:alert] = "Login to see this page."
      redirect '/'
    end
  end
  @verify_login
end

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
  @user = verify_login
  erb :"user_details"
end

get '/users/:id/edit' do
  @user = verify_login
  erb :'edit_user'
end

post '/users/:id/update' do
  @user = verify_login
  @user.update(name: params['name'], email: params['email'])
  redirect "/users/#{@user.id}"
end

post '/users/:id/delete' do
  @user = verify_login
  @user.destroy
  redirect '/users'
end

get '/posts' do
  @posts = Post.all.reverse
  erb :posts
end

get '/posts/:id' do
  @posts = Post.find(params['id'])
  erb :view_post
end

get '/posts/:id/edit' do
  @post = Post.find(params['id'])
  erb :edit_post
end

get '/posts/new' do
  @user = verify_login
  erb :new_post
end

post '/posts/create' do
  post = Post.create(params)
  redirect "/posts"
end

get '/signin' do
  erb :signin
end

post '/logout' do
  session[:user_id] = nil
  @logged_in = false
  redirect '/'
end

post '/login' do
  @user = User.where(email: params['email']).first
  if @user && @user.password == params['password']
    session[:user_id] = @user.id
    flash[:notice] = "You're now logged in."
    redirect "/users/#{session[:user_id]}"
  else
    flash[:alert] = "Please sign in."
    redirect "/signin"
  end
end
