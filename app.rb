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
  erb :home
end

get '/signin' do
  erb :signin
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

post '/logout' do
  session[:user_id] = nil
  @logged_in = false
  redirect '/'
end

get '/users' do
  @user = User.all
  erb :users
end

get '/users/new' do
  erb :signup
end

post '/users/create' do
  u = User.create(params)
  @user = verify_login
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

get '/users/:id/posts' do
  @user = User.find(params['id'])
  @user_posts = Post.where("user_id == ?", params[:id])
  erb :"user_posts"
end

get '/posts' do
  @posts = Post.all.reverse
  erb :posts
end

get '/posts/new' do
  @user = verify_login
  erb :"new_post"
end

get '/posts/:id' do
  @post = Post.find(params['id'])
  erb :view_post
end

get '/posts/:id/edit' do
  @post = Post.find(params['id'])
  erb :edit_post
end

post '/posts/create' do
  @post = Post.new
  @post.user_id = session[:user_id]
  @post.title = params['title']
  @post.body = params['body']
  @post.category = params['category']
  @post.save
  redirect "/posts"
end

post '/comment/:id' do
  @comment = Comment.new
  @comment.post_id = params[:id]
  @comment.body = params['body']
  @comment.commentor_id = params['commentor_id']
  @comment.save
  redirect "posts/#{@comment.post_id}"
end

get '/sayings' do
  @sayings = Saying.all
  erb :sayings
end

get '/sayings/new' do
  erb :"add_saying"
end

post '/sayings/create' do
  @saying = Saying.new
  @saying.author = params['author']
  @saying.phrase = params['phrase']
  @saying.save

  redirect '/'
end

get '/sayings/:id' do
  @saying = Sayings.find(params['id'])
  erb :sayings
end
