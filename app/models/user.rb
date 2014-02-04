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

	def favorite_style
		return nil if beers.empty?
		ratings.order(score: :desc).limit(1).first.beer.style # Tämä kohta palauttaa väärin

#		styles = get_list_of_styles
#		ratings = Rating.where(user:user)
#
#		max = 0
#
#		styles.each do |style|
#			sum = 0
#
#			ratings.each do |rating|
#				if rating.beer.style == style
#					sum += rating.score
#				end
#			end
#
#			max
#		end

#		max_average = 0
#		styles.each do |style|
#			beers = Beer.where(style: style)
#			max_average = beers.
#		end
	end

	private
		def get_list_of_styles
			styles = []
			Beer.all.each do |beer|
				styles.push(beer.style)
			end
			styles.uniq
		end
end
