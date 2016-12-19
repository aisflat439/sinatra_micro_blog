require 'sinatra'
require 'sinatra/activerecord'
require './models'

set :database, "sqlite3:test.sqlite3"

get '/' do
  "hellow world"
end
