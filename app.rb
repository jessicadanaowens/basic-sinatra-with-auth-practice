require "sinatra"
require "rack-flash"

require "./lib/user_database"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @user = []
    @index = 0
  end

  get "/" do
    if session[:user_id]
      @info = find_user_info(session[:user_id])
      erb :logout, :locals => {:info => @info}
    else
      erb :homepage
    end
  end

  post "/registration_form" do
    username = params[:username]
    password = params[:password]
    register(username, password)
  end

  get "/registration_form" do
    erb :registration_form
  end

  post "/sessions" do
    username = params[:username]
    password = params[:password]
    login(username, password)
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

  private

  def check_inputs(username, password, route)

    if username == '' && password == ''
      flash[:notice]= "Username and Password are required"
      redirect route
    elsif username == ''
      flash[:notice]= "Username is required"
      redirect route
    elsif password == ''
      flash[:notice]= "Password is required"
      redirect route
    end
  end

  def login(username, password)
    check_inputs(username, password, "/")
    check_registration(username,password)
    session[:user_id] = user_hash(username).keys[0]

    flash[:notice]= "Welcome"
    redirect "/"
  end

  def register(username, password)
    check_inputs(username, password, "/registration_form")
    check_if_user_exists(username)
    enter_user_in_database(username, password)

    flash[:notice]= "Thank you for registering"
    redirect "/"
  end

  def check_if_user_exists(username)
    @user.each do |user_hash|
      user_hash.each_value do |username_password|
        if username_password[:user] == username
          flash[:notice] = "username already taken"
          redirect '/registration_form'
        end
      end
    end
  end

  def enter_user_in_database(username, password)
    id = {index_key => {:user => username, :pass => password}}
    @user.push(id)
  end

  def index_key
    @user.length + 1
  end

  def user_hash(username)
    @user.find do |user_hash|
      user_hash.each_value do |username_password|
        username_password[:user] == username
      end
    end
  end

  def find_user_info(id)
    @user.find do |user_hash|
      user_hash.has_key?(id)
    end
  end

  def check_registration(username, password)
    if user_hash(username) == nil
      flash[:notice]= "You are not registered"
      redirect '/registration_form'
    else
      if user_hash(username).values[0][:pass] != password
      flash[:notice]= "Incorrect password. Please re-enter."
      redirect back
      end
    end
  end

end