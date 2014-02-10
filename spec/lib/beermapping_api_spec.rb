require 'spec_helper'

describe 'BeermappingApi' do


	it 'When HTTP GET returns no entries, places.size equals zero' do
		canned_answer = <<-eos
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id></id><name></name><status></status><reviewlink></reviewlink><proxylink></proxylink><blogmap></blogmap><street></street><city></city><state></state><zip></zip><country></country><phone></phone><overall></overall><imagecount></imagecount></location></bmp_locations>
		eos

		stub_request(:get, /.*nowhere/).to_return(body: canned_answer, headers: { 'Content-Type' => 'text/xml' })

		places = BeermappingApi.places_in('nowhere')

		expect(places.size).to eq(0)
	end

	it 'When HTTP GET returns one entry, it is parsed and returned' do
		canned_answer = <<-eos
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>13307</id><name>O'Connell's Irish Bar</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=13307</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=13307&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=13307&amp;d=1&amp;type=norm</blogmap><street>Rautatienkatu 24</street><city>Tampere</city><state></state><zip>33100</zip><country>Finland</country><phone>35832227032</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
		eos

		stub_request(:get, /.*tampere/).to_return(body: canned_answer, headers: { 'Content-Type' => 'text/xml' })

		places = BeermappingApi.places_in('tampere')

		expect(places.size).to eq(1)
		place = places.first
		expect(place.name).to eq("O'Connell's Irish Bar")
		expect(place.street).to eq('Rautatienkatu 24')
	end

	it 'When HTTP GET return multiple entries, them are parsed and returned' do
		canned_answer = <<-eos
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>11105</id><name>Bishops Arms, The</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=11105</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=11105&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=11105&amp;d=1&amp;type=norm</blogmap><street>Tyska Torget 2</street><city>Norrköping</city><state></state><zip>60224</zip><country>Sweden</country><phone>+46(0)11-364120</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>11108</id><name>Saliga Munken</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=11108</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=11108&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=11108&amp;d=1&amp;type=norm</blogmap><street>Sankt Persgatan 80</street><city>Norrköping</city><state></state><zip>60233</zip><country>Sweden</country><phone>+46(0)11-133001</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>11366</id><name>Black Lion Inn, The</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=11366</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=11366&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=11366&amp;d=1&amp;type=norm</blogmap><street>Gamla Rådstugugatan 11</street><city>Norrköping</city><state></state><zip></zip><country>Sweden</country><phone>+46(0)11-104105</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
		eos

		stub_request(:get, /.*norrk.*ping/).to_return(body: canned_answer, headers: { 'Content-Type' => 'text/xml' })

		places = BeermappingApi.places_in('norrköping')

		expect(places.size).to eq(3)
		expect(places.first.name).to eq('Bishops Arms, The')
		expect(places.first.street).to eq('Tyska Torget 2')
		expect(places.last.name).to eq('Black Lion Inn, The')
		expect(places.last.street).to eq('Gamla Rådstugugatan 11')
	end
end