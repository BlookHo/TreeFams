shared_examples :successful_connection_request_update do
  it '- check ConnectionRequest row - Ok'  do # , focus: true
      puts "in successful_connection_request_update: request_id = #{request_id.inspect} \n"
    connection_request_fields = ConnectionRequest.find(request_id).attributes.except('created_at','updated_at')
    expect(connection_request_fields).to eq(updated_request )
  end
end

