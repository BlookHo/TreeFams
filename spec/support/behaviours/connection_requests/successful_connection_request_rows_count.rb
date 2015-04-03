shared_examples :successful_connection_request_rows_count do
  it '- check ConnectionRequest have rows count - Ok' do
    connection_request_count =  ConnectionRequest.all.count
    puts "in successful_connection_request_rows_count: connection_request_count = #{connection_request_count.inspect} \n"
    expect(connection_request_count).to eq(rows_qty) # got rows_qty of ConnectionRequest
  end
end

