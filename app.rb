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
    if current_user
      erb :signed_in
    else
    erb :signed_out
    end
  end

  get "/registration/new" do
    erb :"registration/new"
  end

  post "/registration" do
    flash[:message] = "Thank you for registering"
    redirect '/'
  end

  post "/sessions" do

    @user_database.insert(:username => params[:username], :password =>params[:password])
    user = find_user(params)
    session[:user_id] = user[:id] if user
    redirect '/'
  end

  get "/signed_in" do
    redirect '/'
  end

  get "/signed_out" do
    session.delete(:user_id)
    redirect '/'
  end


  private

  #pull out the current user from the @user_database by using params as arguments
  #set the current user equal to user
  #set the sessions id equal to user id

  def find_user(params)
    @user_database.all.select { |username_password|
      username_password[:username] == params[:username] && username_password[:password] == params[:password]
    }.first
  end

  #pull out the user info by inserting the sessions id
  def current_user
    if session[:user_id]
    @user_database.find(session[:user_id])
    end
  end

end



