require 'spec_helper'
include OwnTestHelper

describe 'User' do
	before :each do
		FactoryGirl.create :user
	end

	describe 'who has signed up' do
		it 'can login with right credentials' do
			login(username:'Pekka', password:'Foobar1')

			expect(page).to have_content 'Welcome back!'
			expect(page).to have_content 'Pekka'
		end

		it 'is redirected back to login form if wrong credentials given' do
			login(username:'Pekka', password:'wrong')

			expect(current_path).to eq(login_path)
			expect(page).to have_content 'Username and password do not match'
		end

		it 'when signed up with good credentials, is added to the system' do
			visit signup_path
			fill_in('user_username', with:'Brian')
			fill_in('user_password', with: 'Secret55')
			fill_in('user_password_confirmation', with:'Secret55')

			expect {
				click_button('Create User')
			}.to change{User.count}.by(1)
		end
	end


	it 'can delete own rating' do
		user = FactoryGirl.create(:user, username:'Heikki', password:'Secret1', password_confirmation:'Secret1')
		beer = FactoryGirl.create(:beer)
		FactoryGirl.create(:rating, user:user, beer:beer)

		login(username:'Heikki', password:'Secret1')
		visit user_path(user)
		expect{
			click_link('Delete')
		}.to change{Rating.count}.from(1).to(0)

	end
end