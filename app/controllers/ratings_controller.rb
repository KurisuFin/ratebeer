class RatingsController < ApplicationController
	before_action 'ensure_that_logged_in', except: [:index]

	def index
		# When top lists are calculated, values are used next 10 minutes
		@top_beers = Rails.cache.fetch('beer top 3', expires_in: 10.minutes){ Beer.top 3 }
		@top_breweries = Rails.cache.fetch('brewery top 3', expires_in: 10.minutes){ Brewery.top 3 }
		@top_styles = Rails.cache.fetch('styles top 3', expires_in: 10.minutes){ Style.top 3 }
		@users_with_most_ratings = Rails.cache.fetch('users with most ratings', expires_in: 10.minutes){ User.most_ratings 3 }

		@all_ratings = Rating.includes(:user, :beer).all
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