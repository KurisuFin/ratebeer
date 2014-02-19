json.array!(@breweries) do |brewery|
  json.extract! brewery, :id, :name, :year
  json.beersCount brewery.beers.length
end
