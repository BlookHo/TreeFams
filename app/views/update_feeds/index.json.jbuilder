json.array!(@update_feeds) do |update_feed|
  json.extract! update_feed, :id, :user_id, :update_id, :agent_user_id
  json.url update_feed_url(update_feed, format: :json)
end
