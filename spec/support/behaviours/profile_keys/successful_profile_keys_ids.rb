shared_examples :successful_profile_keys_ids do
  it '- ProfileKey check have rows count & ids before where(deleted: 0) - Ok' do
    profile_keys_count =  ProfileKey.where(deleted: 0).count
    puts "before action: profile_keys_count = #{profile_keys_count.inspect} \n"
    expect(profile_keys_count).to eq(rows_qty) # count of Profile
    profile_keys_ids =  ProfileKey.where(deleted: 0).pluck(:id).sort
    # puts "before action: profile_keys_ids = #{profile_keys_ids.inspect} \n"
    expect(profile_keys_ids).to eq(rows_ids_arr) # ids of ProfileKeys
  end
end


