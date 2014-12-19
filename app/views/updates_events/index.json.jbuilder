json.array!(@updates_events) do |updates_event|
  json.extract! updates_event, :id, :name, :image
  json.url updates_event_url(updates_event, format: :json)
end
