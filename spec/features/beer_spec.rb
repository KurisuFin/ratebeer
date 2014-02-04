require 'spec_helper'

describe 'Beer' do
	let!(:brewery) { FactoryGirl.create(:brewery, name:'Koff')}
	let!(:user) { FactoryGirl.create(:user) }

	before :each do
		login(username:'Pekka', password:'Foobar1')
	end

	it 'is saved with valid name' do
		visit new_beer_path
		fill_in 'beer_name', with:'UusiKalja'
		select('Lager', from:'beer_style')
		select('Koff', from:'beer_brewery_id')

		expect {
			click_button 'Create Beer'
		}.to change{Beer.count}.from(0).to(1)
	end

	it 'is not saved without valid name' do
		visit new_beer_path
		select('Lager', from:'beer_style')
		select('Koff', from:'beer_brewery_id')

		click_button 'Create Beer'

		expect(Beer.count).to eq(0)
		expect(page).to have_content("Name can't be blank")
	end
end