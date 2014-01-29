class Brewery < ActiveRecord::Base
	include RatingAverage

  has_many :beers, dependent: :destroy
	has_many :ratings, through: :beers

	validates :name, presence: true
	validates :year, numericality: { only_integer: true }

	validate :inspect_year

	def inspect_year
		if year < 1042 || year > Date.today.year
			errors.add(:year, "have to be between 1042-#{Date.today.year}")
		end
	end

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
