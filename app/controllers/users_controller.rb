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
        @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password], :photo => '\images\heart.jpg')
        if @user.save
        session[:user_id] = @user.id
        else 
        flash[:taken] = "Username taken."
        redirect to '/login'
        end
      end
    end
  
    get '/login' do
      if !logged_in?
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
    
    patch '/user/:id' do
      if logged_in?
        if params[:email] == ""
          redirect to "/users/#{params[:id]}/edit"
          flash[:change] = "Verify old email and ensure new one matches the confirm field."
        else
          @user = User.find_by_id(params[:id])
          if @user == current_user && params[:email] == params[:confirm_email] && params[:email] != nil
            puts params
            if @user.update(email: params[:email]) 
              redirect to "/"
            else
              redirect to "/users/#{@user.id}/edit"
              flash[:change] = "Verify old email and ensure new one matches the confirm field."
            end
          elsif params[:photo] != ""
            if @user.update(photo: params[:photo]) 
              redirect to "/"
            end
          else
            redirect to '/'
          end
        end
      else
        redirect to '/login'
      end
    end

    post '/user/:id' do
     @user = User.find_by_id(params[:id])
        erb :'index'
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