shared_examples :successful_users_connected do
  it '- Users check connected_users AFTER <connect_trees> and <disconnect_tree> - Ok' do
    user_1_connected_users = User.find(1).connected_users
    user_2_connected_users = User.find(2).connected_users
    user_3_connected_users = User.find(3).connected_users
    puts "In Check Users connected_users: user_1_connected_users = #{user_1_connected_users} \n"
    puts "In Check Users connected_users: user_2_connected_users = #{user_2_connected_users} \n"
    puts "In Check Users connected_users: user_3_connected_users = #{user_3_connected_users} \n"
    expect(user_1_connected_users).to eq(connected_users_arr_1) # connected_users of User 1
    expect(user_2_connected_users).to eq(connected_users_arr_2) # connected_users of User 2
    expect(user_3_connected_users).to eq(connected_users_arr_3) # connected_users of User 3
  end
end


