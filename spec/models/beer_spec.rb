require 'spec_helper'

describe Beer do
	let(:style){ FactoryGirl.create(:style) }

  it 'is saved with a name and style' do
		beer = Beer.create name:'Kalja', style:style

		expect(beer).to be_valid
		expect(Beer.count).to eq(1)
	end

	it 'is not saved without a name' do
		beer = Beer.create name:'', style:style

		expect(beer).not_to be_valid
		expect(Beer.count).to eq(0)
	end

	it 'is not saved without a style' do
		beer = Beer.create name:'Kalja'

		expect(beer).not_to be_valid
		expect(Beer.count).to eq(0)
	end
end

