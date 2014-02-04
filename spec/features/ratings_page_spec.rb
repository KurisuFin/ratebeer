require 'spec_helper'

describe 'Rating page' do
	it 'has ratings and number of ratings' do
		user = FactoryGirl.create(:user)
		beer = FactoryGirl.create(:beer, name:'Kalja')

		amount = 5
		for i in 0..amount-1
			FactoryGirl.create(:rating, user:user, beer:beer, score:10+i)
		end


		visit ratings_path
		expect(page).to have_content "Number of ratings: #{amount}"
		for i in 0..amount-1
			expect(page).to have_content "Kalja #{10+i}"
		end
	end
end