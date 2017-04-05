require_relative 'hangman_driver'
require 'sinatra'
require 'sinatra/reloader'

configure do
  enable :sessions
  set :session_secret, "secret"
end



get '/' do
  @session = session

  erb :index
end