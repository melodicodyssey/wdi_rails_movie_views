class MoviesController < ApplicationController


  # route: GET    /movies(.:format)
  def index
    @movies = Movie.all
    # binding.pry
    respond_to do |format|
      format.html
      format.json { render :json => Movie.all }
      format.xml { render :xml => Movie.all.to_xml }
    end
  end
  # route: # GET    /movies/:id(.:format)
  def show
    # @movie = Movie.find do |m|
    #   m["imdbID"] == params[:id]
    # end

    /movies/:id
    "/movies/4"

    id = params[:id]
    @movie = Movie.find(id)
    if @movie.nil?
      flash.now[:message] = "Movie not found"
      @movie = {}
    end
  end

  def search
    @results = JSON.parse(Typhoeus.get("www.omdbapi.com/", :params => {:s => params[:search]}).body)
  end

  # route: GET    /movies/new(.:format)
  def new
  end

  # route: GET    /movies/:id/edit(.:format)
  def edit
    show
  end

  #route: # POST   /movies(.:format)
  def create
    # create new movie object from params
    movie = params.require(:movie).permit(:title, :year)
    # movie["imdbID"] = rand(10000..100000000).to_s
    # add object to movie db
    Movie.create(movie)
    # show movie page
    # render :index
    redirect_to action: :index
  end

  def add
      results = params[:checked]
      results.each do |title|
      title_year = title.split(",")
      new_movie = {"title" => title_year[0], "year" => title_year[1]}
      # Movie.create(new_movie)
      # Movie.create(title: new_movie["title"], year: new_movie["year"], imdbID: new_movie["imdbID"])
      Movie.create(new_movie)
    end
    redirect_to action: :index
  end

  # route: PATCH  /movies/:id(.:format)
  def update
    #implement
    id = params[:id]
    changes = params.require(:movie).permit(:title, :year)
    # changes = {:title => params[:movie][:title], :year => params[:movie][:year]}
    movie = Movie.find(id)
    movie.update_attributes(changes)
    redirect_to "/movies/#{id}"
  end

  # route: DELETE /movies/:id(.:format)
  def destroy
    #implement
    id = params[:id]
    movie = Movie.find(id)
    Movie.destroy(movie)
    redirect_to "/"
  end

  def next
    # params[:id].nil? ? id = 0 : id = params[:id].to_1 + 1
    # # redirect_to "movies/#{id+1}"
    # @movie = nil
    # while @movie.nil?
    # @movie = Movie.find(id)
    # i += 1
    # end
    # redirect_to action: :show
    id = params[:id]
    @movie = nil
    while @movie == nil
      @movie = Movie.find(id)
      id += 1
    end
    show
  end

  def prev
    movies = Movies.all
    params[:id].nil? ? id = movie.size.to_i : id = params[:id].to_i - 1
    # redirect_to "movies/#{id-1}"
    @movie = Movie.find(id)
    redirect_to action: :show
  end

end
