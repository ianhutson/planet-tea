require './config/environment'
require 'sinatra/flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "tea"
    register Sinatra::Flash
  end

  get '/' do
    erb :index
  end

  helpers do

    def logged_in?
      !!current_user
    end

    def redirect_login
      if !logged_in?
        redirect to '/login'
      end
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

  end
end