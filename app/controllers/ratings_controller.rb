class RatingsController < ApplicationController
	before_action 'ensure_that_logged_in', except: [:index]

	def index
		@top_beers = Beer.top 3
		@top_breweries = Brewery.top 3
		@top_styles = Style.top 3
		@users_with_most_ratings = User.most_ratings 3
		@all_ratings = Rating.all
		@recent_ratings = Rating.recent
	end

	def new
		@rating = Rating.new
		@beers = Beer.all.sort_by{ |beer| beer.name.downcase}
	end

	def create
		@rating = Rating.create params.require(:rating).permit(:score, :beer_id)

		if @rating.save
			current_user.ratings << @rating
			redirect_to current_user
		else
			@beers = Beer.all
			render :new
		end
	end

	def destroy
		rating = Rating.find(params[:id])
		rating.delete
		redirect_to :back
	end
end