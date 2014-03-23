json.array!(@trees) do |tree|
  json.extract! tree, :id, :user_id, :profile_id, :relation_id, :connected
  json.url tree_url(tree, format: :json)
end
