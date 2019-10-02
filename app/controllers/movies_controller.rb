class MoviesController < ApplicationController

  # sorting labels
  @@title_sorted = 'nil'
  @@date_sorted = 'nil'
  @@set_ratings = 'nil'

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
    @ratings_on = {'G'=>'1', 'PG'=>'1', 'PG-13'=>'1', 'R'=>'1'}

    if params[:ratings] != nil
      @ratings_on = params[:ratings]
      @@set_ratings = params[:ratings]
    elsif @@set_ratings != 'nil'
      @ratings_on = @@set_ratings
    end


    # update sorting labels
    if @sort == 'title'
      @@date_sorted = nil

      if @@title_sorted == '0-z'
        @@title_sorted = 'z-0'

      elsif @@title_sorted == 'z-0'
        @@title_sorted = '0-z'

      else
        @@title_sorted = '0-z'
      end
    end

    if @sort == 'release_date'
      @@title_sorted = nil

      if @@date_sorted == 'ascending'
        @@date_sorted = 'descending'

      elsif @@date_sorted == 'descending'
        @@date_sorted = 'ascending'

      else
        @@date_sorted = 'ascending'
      end
    end


    # display movies 
    if @@title_sorted == 'z-0'
      @movies = Movie.all.select {|m| @ratings_on.keys.include?(m.rating)}.sort_by { |m| m.title }.reverse

    elsif @@title_sorted =='0-z'
      @movies = Movie.all.select {|m| @ratings_on.keys.include?(m.rating)}.sort_by { |m| m.title }

    elsif @@date_sorted == 'descending'
      @movies = Movie.all.select {|m| @ratings_on.keys.include?(m.rating)}.sort_by { |m| m.release_date }.reverse
    
    elsif @@date_sorted == 'ascending'
      @movies = Movie.all.select {|m| @ratings_on.keys.include?(m.rating)}.sort_by { |m| m.release_date }
    
    else
      @movies = Movie.all.select{|m| @ratings_on.keys.include?(m.rating)}
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
