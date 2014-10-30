json.array!(@messages) do |message|
  json.extract! message, :id, :text, :sender_id, :receiver_id, :read, :sender_deleted, :receiver_deleted
  json.url message_url(message, format: :json)
end
