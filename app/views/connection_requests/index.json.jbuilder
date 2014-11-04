json.array!(@connection_requests) do |connection_request|
  json.extract! connection_request, :id, :user_id, :with_user_id, :confirm, :done
  json.url connection_request_url(connection_request, format: :json)
end
