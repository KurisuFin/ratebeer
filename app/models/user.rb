class User < ActiveRecord::Base
	include RatingAverage

	has_secure_password

	has_many :ratings
	has_many :beers, through: :ratings
	has_many :memberships
	has_many :beer_clubs, through: :memberships

	validates :username, uniqueness: true,
											 length: { minimum: 3,
											 					 maximum: 15 }
	validates :password, format: { with: /(?=.*[A-Z])(?=.*\d).{4,}/ }

	def favorite_beer
		return nil if ratings.empty?
		ratings.order(score: :desc).limit(1).first.beer
	end

	def is_member_of(beer_club)
		BeerClub.find(beer_club).members.exists?(self)
	end

	def favorite_style
		return nil if beers.empty?

		ratings = Rating.where(user:self).inject({}) do |result, rating|
			result[rating.beer.style] = [] if result[rating.beer.style].nil?
			result[rating.beer.style].push(rating.score)
			result
		end

		find_the_one_with_biggest_average ratings
	end

	def favorite_brewery
		return nil if beers.empty?

		ratings = Rating.where(user:self).inject({}) do |result, rating|
			result[rating.beer.brewery] = [] if result[rating.beer.brewery].nil?
			result[rating.beer.brewery].push(rating.score)
			result
		end

		(find_the_one_with_biggest_average ratings).name
	end

	private

		def find_the_one_with_biggest_average(ratings)
			ratings.keys.max_by{ |key| ratings[key].sum / ratings[key].count }
		end
end
