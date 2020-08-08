class UsersController < ApplicationController
    get '/signup' do
      if !logged_in?
        erb :'index'
      else
        redirect to '/reviews'
      end
    end
  
    post '/signup' do
      if params[:username] == "" || params[:email] == "" || params[:password] == ""
        flash[:signup] = "Please enter a valid username, email, and password."
        redirect to '/'
      else
        @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
        @user.save
        session[:user_id] = @user.id
        redirect to '/reviews'
      end
    end
  
    get '/login' do
      if !logged_in?
        flash[:login] = "Invalid credentials."
        erb :'index'
      else
        redirect to '/reviews'
      end
    end
  
    post '/login' do
      user = User.find_by(:username => params[:username])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect to "/reviews"
      else
        flash[:login] = "Invalid credentials."
        redirect to '/'
      end
    end

    get '/users/:id/edit' do
      if logged_in?
        @user = User.find_by_id(params[:id])
        if @user == current_user
          erb :'users/profile_edit'
        else
          redirect to '/'
        end
      else
        redirect to '/login'
      end
    end
  
    patch '/users/:id' do
      if logged_in?
        if params[:name] == ""
          redirect to "/users/#{params[:id]}/edit"
        else
          @user = User.find_by_id(params[:id])
          if @user == current_user && params[:password] == params[:confirm_password]
            if @user.update(password: params[:password]) 
              redirect to "/users/#{@user.id}"
            else
              redirect to "/users/#{@user.id}/edit"
            end
          else
            redirect to '/users'
          end
        end
      else
        redirect to '/login'
      end
    end

    get '/logout' do
      if logged_in?
        session.destroy
        redirect to '/'
      else
        redirect to '/'
      end
    end

  end