shared_examples :successful_connection_logs_rows_count do
  it '- check ConnectionLog have rows count - Ok' do
    connection_logs_count =  ConnectionLog.all.count
    puts "in successful_connection_logs_rows_count: connection_logs_count = #{connection_logs_count.inspect} \n"
    expect(connection_logs_count).to eq(rows_qty) # got rows_qty of ConnectionLog
  end
end
