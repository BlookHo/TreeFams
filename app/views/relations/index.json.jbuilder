json.array!(@relations) do |relation|
  json.extract! relation, :id, :relation
  json.url relation_url(relation, format: :json)
end
