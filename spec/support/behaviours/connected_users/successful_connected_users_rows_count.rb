shared_examples :successful_connected_users_rows_count do
  it '- check ConnectedUser have rows count - Ok' do
    connected_users_count =  ConnectedUser.all.count
    puts "in successful_connected_users_rows_count: connected_users_count = #{connected_users_count.inspect} \n"
    expect(connected_users_count).to eq(rows_qty) # got rows_qty of ConnectedUser
  end
end

