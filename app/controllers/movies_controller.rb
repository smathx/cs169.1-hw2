class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    redirect = false    
    order_by = params[:order_by]
    
    if order_by.nil?
      order_by = session[:order_by]
      redirect = ! order_by.nil?
    else
      session[:order_by] = order_by
    end
    
    @all_ratings = Movie.all_ratings
    @chosen_ratings = @all_ratings
    
    if not params[:ratings].nil?
      @chosen_ratings = params[:ratings].keys
      session[:ratings] = @chosen_ratings
    elsif not session[:ratings].nil?
      @chosen_ratings = session[:ratings]      
      redirect = true
    end
    
    if order_by == "title"
      @title_header_class = 'hilite'
      @sort_order = { title: :asc }
      
    elsif order_by == "date"
      @date_header_class = 'hilite'
      @sort_order = { release_date: :asc }
    end
    
    if redirect
      ratings_hash = {}
      @chosen_ratings.each { |key| ratings_hash[key] = 1 }
      redirect_to order_by: order_by, ratings: ratings_hash
    else
      @movies = Movie.where(rating: @chosen_ratings).order(@sort_order)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
