shared_examples :successful_profiles_deleted_arr do
  it '- Profile check have rows count & ids before - Ok' do
    puts "In Check Profiles deleted: opposite_profiles_arr = #{opposite_profiles_arr} \n"
    profiles_deleted_arr = []
    opposite_profiles_arr.each do |one_profile|
      profiles_deleted_arr << Profile.find(one_profile).deleted
    end
    profiles_deleted_arr
    puts "In Check Profiles deleted: profiles_deleted_arr = #{profiles_deleted_arr} \n"

    expect(profiles_deleted_arr).to eq(profiles_deleted) # array of deleted Profiles
  end
end


