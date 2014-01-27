class Brewery < ActiveRecord::Base
	include RatingAverage

  has_many :beers, dependent: :destroy
	has_many :ratings, through: :beers

	def print_report
		puts name
		puts " Established at year #{year}"
		puts " Number of beers #{beers.count}"
		puts " Number of ratings #{ratings.count}"
	end

	def restart
		self.year = 2014
		puts "Changed year to #{year}"
	end
end
