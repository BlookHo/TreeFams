json.array!(@users) do |user|
  json.extract! user, :id, :profile_id, :admin, :rating
  json.url user_url(user, format: :json)
end
