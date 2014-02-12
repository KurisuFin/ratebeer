# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

s1 = Style.create name:'IPA'
s2 = Style.create name:'Lager'
s3 = Style.create name:'Pale ale'
s4 = Style.create name:'Porter'
s5 = Style.create name:'Weizen'

b1 = Brewery.create name:'Koff', year:1897
b2 = Brewery.create name:'Malmgard', year:2001
b3 = Brewery.create name:'Weihenstephaner', year:1042

b1.beers.create name:'Iso 3', style:s2
b1.beers.create name:'Karhu', style:s2
b1.beers.create name:'Tuplahumala', style:s2
b2.beers.create name:'Huvila Pale Ale', style:s3
b2.beers.create name:'X Porter', style:s4
b3.beers.create name:'Hefezeizen', style:s5
b3.beers.create name:'Helles', style:s2

bc1 = BeerClub.create name:'Kallion spurgut', founded:1550
bc2 = BeerClub.create name:'Luukkaisen salakapakka', founded:1991
