json.array!(@names) do |name|
  json.extract! name, :id, :name, :only_male
  json.url name_url(name, format: :json)
end
