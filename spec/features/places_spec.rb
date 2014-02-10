require 'spec_helper'

describe 'Places' do
	it 'if one is returned by the API, it is shown at the page' do
		BeermappingApi.stub(:places_in).with('Kumpula').and_return(
				[ Place.new(name: 'Oljenkorsi') ]
		)

		visit places_path
		fill_in('city', with: 'Kumpula')
		click_button 'Search'

		expect(page).to have_content 'Oljenkorsi'
	end

	it 'if more than one is returned by the API, all is shown at the page' do
		BeermappingApi.stub(:places_in).with('Kumpula').and_return(
				[ Place.new(name: 'Oljenkorsi'),
					Place.new(name: 'Luukkaisen salakapakka') ]
		)

		visit places_path
		fill_in('city', with: 'Kumpula')
		click_button 'Search'

		expect(page).to have_content 'Oljenkorsi'
		expect(page).to have_content 'Luukkaisen salakapakka'
	end

	it 'if none is returned by the API, notice is shown at the page' do
		visit places_path
		fill_in('city', with: 'Heaven')
		click_button 'Search'

		expect(page).to have_content 'No locations in Heaven'
	end
end