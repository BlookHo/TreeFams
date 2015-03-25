shared_examples :successful_profile_keys_profile_ids do
  it '- check all profile_ids generated in ProfileKey rows - Ok' do
    all_profile_ids =  ProfileKey.all.pluck(:profile_id).sort
    expect(all_profile_ids).to eq(profiles_ids_arr) # got all_profile_ids for all rows of ProfileKey
    puts "In check ProfileKey: all_profile_ids = #{all_profile_ids.size} \n"
    expect(all_profile_ids.size).to eq(profiles_ids_arr_size)
  end
end
