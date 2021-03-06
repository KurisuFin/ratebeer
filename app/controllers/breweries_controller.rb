class BreweriesController < ApplicationController
  before_action :set_brewery, only: [:show, :edit, :update, :destroy]
	before_action :ensure_that_logged_in, except: [:index, :show]
	before_action :skip_if_cached, only: [:index]
	before_action :expire_brewerylist_fragment, only: [:create, :update, :destroy]

  # GET /breweries
  # GET /breweries.json
  def index
    @active_breweries = Brewery.active
		@retired_breweries = Brewery.retired

		case @order
			when 'name' then @active_breweries.sort_by!{ |b| b.name.downcase }
			when 'year' then @active_breweries.sort_by!{ |b| b.year }
		end
	end

	def list
	end

  # GET /breweries/1
  # GET /breweries/1.json
  def show
  end

  # GET /breweries/new
  def new
    @brewery = Brewery.new
  end

  # GET /breweries/1/edit
  def edit
  end

  # POST /breweries
  # POST /breweries.json
  def create
    @brewery = Brewery.new(brewery_params)

    respond_to do |format|
      if @brewery.save
        format.html { redirect_to @brewery, notice: 'Brewery was successfully created.' }
        format.json { render action: 'show', status: :created, location: @brewery }
      else
        format.html { render action: 'new' }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /breweries/1
  # PATCH/PUT /breweries/1.json
  def update
    respond_to do |format|
      if @brewery.update(brewery_params)
        format.html { redirect_to @brewery, notice: 'Brewery was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /breweries/1
  # DELETE /breweries/1.json
  def destroy
		ensure_that_admin
    @brewery.destroy
    respond_to do |format|
      format.html { redirect_to breweries_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_brewery
      @brewery = Brewery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brewery_params
      params.require(:brewery).permit(:name, :year, :active)
		end

		def skip_if_cached
			@order = params[:order] || 'name'
			render :index if fragment_exist?("brewerylist-#{params[:order]}")
		end

		def expire_brewerylist_fragment
			%w(brewerylist-name brewerylist-year).each{ |f| expire_fragment(f) }
		end
end
