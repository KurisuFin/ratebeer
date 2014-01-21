module RatingAverage
	def average_rating
		sum = ratings.inject(0.0) { |result, rating| result + rating.score }
		(sum / ratings.count).round(1)
	end
end