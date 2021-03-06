require 'spec_helper'

describe User do
  it 'has the username set correctly' do
		user = User.new username:'Pekka'

		expect(user.username).to eq('Pekka')
	end

	it 'is not saved without a password' do
		user = User.create username:'Pekka'

		expect(user).not_to be_valid
		expect(User.count).to eq(0)
	end


	describe 'with a proper password' do
		let(:user){ FactoryGirl.create(:user) }

		it 'is saved' do
			expect(user).to be_valid
			expect(User.count).to eq(1)
		end

		it 'and with two ratings, has the correct average rating' do
			rating = Rating.new score:10
			rating2 = Rating.new score:20

			user.ratings << rating
			user.ratings << rating2

			expect(user.ratings.count).to eq(2)
			expect(user.average_rating).to eq(15.0)
		end
	end


	it 'is not saved with too short password' do
		user = User.create username:'Pekka', password:'A1b', password_confirmation:'A1b'

		expect(user).not_to be_valid
		expect(User.count).to eq(0)
	end

	it 'is not saved with a password which contains only alphabets' do
		user = User.create username:'Pekka', password:'AAAaaa', password_confirmation:'AAAaaa'

		expect(user).not_to be_valid
		expect(User.count).to eq(0)
	end


	describe 'favorite beer' do
		let(:user){ FactoryGirl.create(:user) }

		it 'has method for determining one' do
			user.should respond_to :favorite_beer
		end

		it 'without ratings does not have a favorite beer' do
			expect(user.favorite_beer).to eq(nil)
		end

		it 'is the only rated if only one rating' do
			beer = create_beer_with_rating(10, user)

			expect(user.favorite_beer).to eq(beer)
		end

		it 'is the one with highest rating if several rated' do
			create_beer_with_rating(10, user)
			best = create_beer_with_rating(25, user)
			create_beer_with_rating(7, user)

			expect(user.favorite_beer).to eq(best)
		end
	end


	describe 'favorite style' do
		let(:user){ FactoryGirl.create(:user) }
		let(:style1){ FactoryGirl.create(:style, name:'Weizen') }
		let(:style2){ FactoryGirl.create(:style, name:'IPA') }
		let(:style3){ FactoryGirl.create(:style, name:'Porter') }

		it 'has method for determining one' do
			user.should respond_to :favorite_style
		end

		it 'without ratings does not have a favorite style' do
			expect(user.favorite_style).to eq(nil)
		end

		it 'is the only rated if only one rating' do
			create_beer_with_rating_and_style(10, style2, user)

			expect(user.favorite_style.name).to eq('IPA')
		end

		it 'is the one with highest rating if maximum of one for every style is rated' do
			create_beer_with_rating_and_style(10, style1, user)
			create_beer_with_rating_and_style(25, style2, user)
			create_beer_with_rating_and_style(7, style3, user)

			expect(user.favorite_style.name).to eq('IPA')
		end

		it 'is the one with highest average rating if several is rated' do
			create_beers_with_ratings_and_style(5, 50, style1, user)
			create_beers_with_ratings_and_style(30, 30, style2, user)
			create_beers_with_ratings_and_style(20, 20, 20, 20, 20, style3, user)

			expect(user.favorite_style.name).to eq('IPA')
		end
	end


	describe 'favorite brewery' do
		let(:user){ FactoryGirl.create(:user) }

		it 'has method for determining one' do
			user.should respond_to :favorite_brewery
		end

		it 'without ratings does not have a favorite brewery' do
			expect(user.favorite_style).to eq(nil)
		end

		it 'is the only rated if only one rating' do
			brewery = FactoryGirl.create(:brewery)
			create_beer_with_rating_and_brewery(30, brewery, user)
			expect(user.favorite_brewery).to eq(brewery.name)
		end

		it 'is the one with highest rating if maximum of one for every brewery is rated' do
			brewery1 = FactoryGirl.create(:brewery)
			brewery2 = FactoryGirl.create(:brewery)
			brewery3 = FactoryGirl.create(:brewery)

			create_beer_with_rating_and_brewery(10, brewery1, user)
			create_beer_with_rating_and_brewery(30, brewery2, user)
			create_beer_with_rating_and_brewery(20, brewery3, user)

			expect(user.favorite_brewery).to eq(brewery2.name)
		end

		it 'is the one with highest average rating if several is rated' do
			brewery1 = FactoryGirl.create(:brewery)
			brewery2 = FactoryGirl.create(:brewery)
			brewery3 = FactoryGirl.create(:brewery)

			create_beers_with_ratings_and_brewery(5, 50, brewery1, user)
			create_beers_with_ratings_and_brewery(30, 30, brewery2, user)
			create_beers_with_ratings_and_brewery(20, 20, 20, 20, 20, brewery3, user)

			expect(user.favorite_brewery).to eq(brewery2.name)
		end
	end
end


def create_beer_with_rating_and_brewery(score, brewery, user)
	beer = FactoryGirl.create(:beer, brewery:brewery)
	FactoryGirl.create(:rating, score:score, beer:beer, user:user)
end

def create_beers_with_ratings_and_brewery(*scores, brewery, user)
	scores.each do |score|
		create_beer_with_rating_and_brewery(score, brewery, user)
	end
end



def create_beer_with_rating_and_style(score, style, user)
	beer = FactoryGirl.create(:beer, style:style)
	FactoryGirl.create(:rating, score:score, beer:beer, user:user)
	beer
end

def create_beers_with_ratings_and_style(*scores, style, user)
	scores.each do |score|
		create_beer_with_rating_and_style(score, style, user)
	end
end



def create_beer_with_rating(score, user)
	beer = FactoryGirl.create(:beer)
	FactoryGirl.create(:rating, score:score, beer:beer, user:user)
	beer
end

def create_beers_with_ratings(*scores, user)
	scores.each do |score|
		create_beer_with_rating(score, user)
	end
end





















