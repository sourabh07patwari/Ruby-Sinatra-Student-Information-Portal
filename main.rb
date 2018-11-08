require 'sinatra'
require 'sinatra/reloader'
require './comments'
require './students'
require 'sass'

configure :production do
    DataMapper.setup(:default, ENV['DATABASE_URL']|| "sqlite3://#{Dir.pwd}/scuwebapp.db") #connecting to db
end

configure :development do
    DataMapper.setup(:default, ENV['DATABASE_URL']|| "sqlite3://#{Dir.pwd}/scuwebapp.db") #connecting to db
end

# enable sessions for remembering browser
configure do
  enable :sessions
  set :session_secrete, "love" #Set the session_secrete
  set :username, "admin" #Set the username and password
  set :password, "admin"
end

# To get to login page
get '/login' do
  @title = "Student Information System - Login"
  erb :login_form #access the view login_form.erb
end

# Get the credentials from login page and display then display the view of Logged in
post '/login' do
  if params[:username] == settings.username && params[:password] == settings.password
    session[:admin] = true
    erb :logged
  end
end

# To get to logout page and display the view of logout
get '/logout' do
  session[:admin] = false
  session.clear
  erb :logout
end

# To get to home page of web app
get '/' do
  @title = "Student Information System - Home"
  erb :home
end

# To get to about page of web app
get '/about' do
  @title = "Student Information System - About"
  erb :about
end

# To get to contact page of web app
get '/contact' do
  @title = "Student Information System - Contact"
  erb :contact
end

# To get to the video page of web app
get '/video' do
  @title = "Student Information System - Video"
  erb :video_home
end

# If any request is not available in routes
not_found do
  @title = "Student Information System - 404 Error"
  erb :notfound
end
