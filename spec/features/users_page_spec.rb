require 'spec_helper'
include OwnTestHelper

describe 'User page' do
	let!(:user){ FactoryGirl.create(:user) }

	it 'doesn\'t contain favorite style if no rating is given' do
		login(username:'Pekka', password:'Foobar1')

		['Weizen', 'Lager', 'Pale ale', 'IPA', 'Porter'].each do |style|
			expect(page).to_not have_content(style)
		end
	end

	describe 'with ratings of user' do
		let!(:brewery1){ FactoryGirl.create(:brewery, name:'Panimo 1') }
		let!(:brewery2){ FactoryGirl.create(:brewery, name:'Panimo 2') }
		let!(:brewery3){ FactoryGirl.create(:brewery, name:'Panimo 3') }
		let!(:beer1){ FactoryGirl.create(:beer, brewery:brewery1, style:'Lager', name:'LagerBeer') }
		let!(:beer2){ FactoryGirl.create(:beer, brewery:brewery2, style:'IPA', name:'IPA-beer') }
		let!(:beer3){ FactoryGirl.create(:beer, brewery:brewery3, style:'Porter', name:'PorterBeer') }

		before :each do
			FactoryGirl.create(:rating, user:user, beer:beer1, score:20)
			FactoryGirl.create(:rating, user:user, beer:beer1, score:20)
			FactoryGirl.create(:rating, user:user, beer:beer1, score:20)
			FactoryGirl.create(:rating, user:user, beer:beer2, score:25)
			FactoryGirl.create(:rating, user:user, beer:beer2, score:25)
			FactoryGirl.create(:rating, user:user, beer:beer3, score:40)
			FactoryGirl.create(:rating, user:user, beer:beer3, score:4)
		end

		it 'contains favorite style' do
			login(username:'Pekka', password:'Foobar1')
			expect(page).to have_content('Favorite style: IPA')
		end

		it 'contains favorite brewery' do
			login(username:'Pekka', password:'Foobar1')
			expect(page).to have_content("Favorite brewery: #{brewery2.name}")
		end

		it 'contains ratings given by user and no other ratings' do
			another_user = FactoryGirl.create(:user, username:'anotherguy', password:'Secret1', password_confirmation:'Secret1')
			another_beer = FactoryGirl.create(:beer, name:'Another Beer')
			FactoryGirl.create(:rating, user:another_user, beer:beer1, score:7)
			FactoryGirl.create(:rating, user:another_user, beer:beer2, score:8)
			FactoryGirl.create(:rating, user:another_user, beer:another_beer, score:9)

			visit user_path(user)

			expect(page).to have_content('LagerBeer 20')
			expect(page).to have_content('IPA-beer 25')
			expect(page).to have_content('PorterBeer 40')
			expect(page).to have_content('PorterBeer 4')
			expect(page).to_not have_content('LagerBeer 7')
			expect(page).to_not have_content('IPA-beer 8')
			expect(page).to_not have_content('Another Beer')
		end
	end
end