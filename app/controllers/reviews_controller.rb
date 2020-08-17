class ReviewsController < ApplicationController
    get '/reviews' do
      redirect_login
      @reviews = current_user.reviews.all
      erb :'reviews/reviews'
    end
  
    get '/reviews/new' do
      redirect_login
      erb :'reviews/create_review'
    end
  
    post '/reviews' do
      redirect_login
        if params[:name] == ""
          flash[:no_name] = "Name field must not be blank."
          redirect to "/reviews/new"
        else
          @review = current_user.reviews.build(name: params[:name], color: params[:color], flavor: params[:flavor], tea_type: params[:tea_type], country: params[:country], supplier: params[:supplier], notes: params[:notes])
          if @review.save
            redirect to "/reviews/#{@review.id}"
          else
            redirect to "/reviews/new"
          end
        end
    end
  
    get '/reviews/:id' do
      redirect_login
      @review = Review.find_by_id(params[:id])
      erb :'reviews/show_review'
    end
  
    get '/reviews/:id/edit' do
      redirect_login
        @review = Review.find_by_id(params[:id])
        if @review && @review.user == current_user
          erb :'reviews/edit_review'
        else
          redirect to '/reviews'
        end  
    end
  
    patch '/reviews/:id' do
      if logged_in?
        if params[:name] == ""
          redirect to "/reviews/#{params[:id]}/edit"
        else
          @review = Review.find_by_id(params[:id])
          if @review && @review.user == current_user
            if @review.update(name: params[:name], color: params[:color], flavor: params[:flavor], tea_type: params[:tea_type], country: params[:country], supplier: params[:supplier], notes: params[:notes])
              redirect to "/reviews/#{@review.id}"
            else
              redirect to "/reviews/#{@review.id}/edit"
            end
          else
            redirect to '/reviews'
          end
        end
      end
    end
  
    delete '/reviews/:id/delete' do
      redirect_login
        @review = Review.find_by_id(params[:id])
        if @review && @review.user == current_user
          @review.delete
        end
        redirect to '/reviews'
    end
  end
  