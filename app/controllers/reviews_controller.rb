class ReviewsController < ApplicationController
    get '/reviews' do
      if logged_in?
        @reviews = Review.all
        erb :'reviews/reviews'
      else
        redirect to '/login'
      end
    end
  
    get '/reviews/new' do
      if logged_in?
        erb :'reviews/create_review'
      else
        redirect to '/login'
      end
    end
  
    post '/reviews' do
      if logged_in?
        if params[:name] == ""
          redirect to "/reviews/new"
        else
          @review = current_user.reviews.build(name: params[:name], color: params[:color], flavor: params[:flavor], tea_type: params[:tea_type], country: params[:country], supplier: params[:supplier], notes: params[:notes])
          if @review.save
            redirect to "/reviews/#{@review.id}"
          else
            redirect to "/reviews/new"
          end
        end
      else
        redirect to '/login'
      end
    end
  
    get '/reviews/:id' do
      if logged_in?
        @review = Review.find_by_id(params[:id])
        erb :'reviews/show_review'
      else
        redirect to '/login'
      end
    end
  
    get '/reviews/:id/edit' do
      if logged_in?
        @review = Review.find_by_id(params[:id])
        if @review && @review.user == current_user
          erb :'reviews/edit_review'
        else
          redirect to '/reviews'
        end
      else
        redirect to '/login'
      end
    end
  
    patch '/reviews/:id' do
      if logged_in?
        if params[:name] == ""
          redirect to "/reviews/#{params[:id]}/edit"
        else
          @review = Review.find_by_id(params[:id])
          if @review && @review.user == current_user
            if @review.update(name: params[:name])
              redirect to "/reviews/#{@review.id}"
            else
              redirect to "/reviews/#{@review.id}/edit"
            end
          else
            redirect to '/reviews'
          end
        end
      else
        redirect to '/login'
      end
    end
  
    delete '/reviews/:id/delete' do
      if logged_in?
        @review = Review.find_by_id(params[:id])
        if @review && @review.user == current_user
          @review.delete
        end
        redirect to '/reviews'
      else
        redirect to '/login'
      end
    end
  end
  