shared_examples :successful_connected_users_rewrite_profile_ids do
  it '- check all rewrite_profile_ids generated in ConnectedUser rows - Ok' do
    all_rewrite_profile_ids_arr =  ConnectedUser.all.pluck(:rewrite_profile_id).sort
    # puts "After ADD Son_to_Author Check ProfileKey \n"
    expect(all_rewrite_profile_ids_arr).to eq(rewrite_profile_ids_arr) # got all_rewrite_profile_ids for all rows of ConnectedUser
    puts "In check ConnectedUser: all_rewrite_profile_ids_arr = #{all_rewrite_profile_ids_arr.size} \n"
    expect(all_rewrite_profile_ids_arr.size).to eq(rewrite_profile_ids_arr_size)
  end
end

shared_examples :successful_connected_users_overwrite_profile_ids do
  it '- check all overwrite_profile_ids generated in ConnectedUser rows - Ok' do
    all_overwrite_profile_ids_arr =  ConnectedUser.all.pluck(:overwrite_profile_id).sort
    # puts "After ADD Son_to_Author Check ProfileKey \n"
    expect(all_overwrite_profile_ids_arr).to eq(overwrite_profile_ids_arr) # got all_overwrite_profile_ids_arr for all rows of ConnectedUser
    puts "In check ConnectedUser: all_overwrite_profile_ids_arr = #{all_overwrite_profile_ids_arr.size} \n"
    expect(all_overwrite_profile_ids_arr.size).to eq(overwrite_profile_ids_arr_size)
  end
end
