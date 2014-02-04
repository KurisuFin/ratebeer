require 'spec_helper'

describe 'User page' do

	it 'contains ratings given by user and no other ratings' do
		user = FactoryGirl.create(:user)
		another_user = FactoryGirl.create(:user, username:'anotherguy', password:'Secret1', password_confirmation:'Secret1')
		beer1 = FactoryGirl.create(:beer, name:'Kalja1')
		beer2 = FactoryGirl.create(:beer, name:'Kalja2')
		beer3 = FactoryGirl.create(:beer, name:'Kalja3')

		FactoryGirl.create(:rating, user:user, beer:beer1, score:10)
		FactoryGirl.create(:rating, user:user, beer:beer2, score:14)
		FactoryGirl.create(:rating, user:another_user, beer:beer2, score:5)
		FactoryGirl.create(:rating, user:another_user, beer:beer3, score:7)

		visit user_path(user)

		expect(page).to have_content('Kalja1 10')
		expect(page).to have_content('Kalja2 14')
		expect(page).to_not have_content('Kalja2 5')
		expect(page).to_not have_content('Kalja3 7')
	end
end