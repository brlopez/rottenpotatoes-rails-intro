class MoviesController < ApplicationController

  @@title_sorted = 'nil'
  @@date_sorted = 'nil'

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @sort = params[:sort]

    if @sort == 'title'
      if @@title_sorted == 'z-0'
        @movies = Movie.all.sort_by { |m| m.title }
        @@title_sorted = '0-z'
      elsif @@title_sorted =='0-z'
        @movies = Movie.all.sort_by { |m| m.title }.reverse
        @@title_sorted = 'z-0'
      else
        @movies = Movie.all.sort_by { |m| m.title }
        @@title_sorted = '0-z'
      end
      
    elsif @sort == 'release_date'
      if @@date_sorted == 'descending' 
        @movies = Movie.all.sort_by { |m| m.release_date }
        @@date_sorted = 'ascending'
      elsif @@date_sorted == 'ascending'
        @movies = Movie.all.sort_by { |m| m.release_date }.reverse
        @@date_sorted == 'descending'
      else
        @movies = Movie.all.sort_by { |m| m.release_date }
        @@date_sorted = 'ascending'
      end
      
    else
      @movies = Movie.all
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
