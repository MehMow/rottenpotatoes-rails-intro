class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index 
    @all_ratings = Movie.all_ratings 
    @movies = Movie.all
    
    if params[:home] == nil #that means coming from somewhere else; so reload session
      #if session[:ratings] == nil 
      #  params[:ratings] = nil
    #  else
      #  params[:ratings] = session[:ratings].to_h() {|s| [s, 1]}
      #end
      params[:sort_date] = session[:sort_date]  
      params[:sort_title] = session[:sort_title]
    end
    
    if params[:form_home] == nil
      params[:ratings] = session[:ratings].to_h() {|s| [s, 1]}
    else
      params[:ratings] = params[:ratings]
    end
      
      
    if params[:ratings] == nil
      @ratings_to_show = []
      session[:ratings]=@ratings_to_show
      @movies = Movie.with_ratings(@ratings_to_show)#.all changed in part 1
    elsif params[:ratings] != nil
      @ratings_to_show = params[:ratings].keys      
      session[:ratings]=@ratings_to_show
      @movies = Movie.with_ratings(@ratings_to_show)#.all changed in part 1
    end
      
      
    if params[:sort_title] != nil
      if params[:ratings] == nil
        @ratings_to_show = []
      else params[:ratings] != nil
        @ratings_to_show = params[:ratings].keys
      end   
      session[:ratings] = @ratings_to_show
      session[:sort_title]=1
      session[:sort_date] = nil
      
      @movies = Movie.with_ratings(@ratings_to_show)
      @movies = @movies.order(:title)
      @turn_on_title = "bg-warning"
      
    elsif params[:sort_date] != nil
      if params[:ratings] == nil
        @ratings_to_show = []
      else params[:ratings] != nil
        @ratings_to_show = params[:ratings].keys
      end
      session[:ratings] = @ratings_to_show
      session[:sort_date] = 1
      session[:sort_title] = nil
      
      @movies = Movie.with_ratings(@ratings_to_show)    
      @movies = @movies.order(:release_date)
      @turn_on_date = "bg-warning"
    #else
    #  @movies = Movie.all
    
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
  


  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
