json.array!(@updates_feeds) do |updates_feed|
  json.extract! updates_feed, :id, :user_id, :update_id, :agent_user_id
  json.url updates_feed_url(updates_feed, format: :json)
end
