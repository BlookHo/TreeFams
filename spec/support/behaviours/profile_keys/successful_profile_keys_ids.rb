shared_examples :successful_profile_keys_ids do
  it '- ProfileKey check have rows count & ids before - Ok' do
    profile_keys_count =  ProfileKey.all.count
    puts "before action: profile_keys_count = #{profile_keys_count.inspect} \n"
    expect(profile_keys_count).to eq(rows_qty) # count of Profile
    profile_keys_ids =  ProfileKey.all.pluck(:id).sort
    # puts "before action: profile_keys_ids = #{profile_keys_ids.inspect} \n"
    expect(profile_keys_ids).to eq(rows_ids_arr) # ids of ProfileKeys
  end
end


