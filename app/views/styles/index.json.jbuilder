json.array!(@styles) do |style|
  json.extract! style, :id, :text
  json.url style_url(style, format: :json)
end
