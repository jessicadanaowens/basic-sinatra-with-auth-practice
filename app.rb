require "sinatra"
require "rack-flash"

require "./lib/user_database"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @user_database = UserDatabase.new
  end

  get "/" do
    "Hello, world"
    erb :homepage
  end

  post "/registration_form" do
    flash[:notice]= "Thank you for registering"
    redirect "/"
  end

  get "/registration_form" do
    erb :registration_form
  end

  post "/sessions" do
    #insert the session object as the user and insert the username and password into @users
    #@users is an array of hashes where the session points to a hash that contains the attributes

    cookie = (session[:user_id] = 1)
    username = params[:username]
    password = params[:password]
    # @user_database.insert(cookie)
    # @user_database.validate!(cookie, {username => params[:username], password => params[:password]})
    flash[:notice]= "Welcome #{username}"
    redirect "/logout"
  end

  get "/logout" do
    erb :logout
  end

  post "/logout" do
    session.delete(:user_id)
    redirect "/"
  end

  post "/" do
    erb :homepage
  end


end
