class Style < ActiveRecord::Base
	include RatingAverage

	has_many :beers
	has_many :ratings, through: :beers

	def self.top(n)
		sorted = Style.all.sort_by{ |s| -(s.average_rating || 0) }
		sorted.take(n)
	end

	def to_s
		self.name
	end
end
