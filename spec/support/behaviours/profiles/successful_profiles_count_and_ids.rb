shared_examples :successful_profiles_count_and_ids do
  it '- Profile check have rows count & ids before - Ok' do
    profiles_count =  Profile.all.count
    puts "profiles_count = #{profiles_count.inspect} \n"
    expect(profiles_count).to eq(rows_qty) # count of Profile
    profiles_ids =  Profile.all.pluck(:id).sort
    puts "profiles_ids = #{profiles_ids.inspect} \n"
    expect(profiles_ids).to eq(rows_ids_arr)  # ids of Profiles
  end
end


