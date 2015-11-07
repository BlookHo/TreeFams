shared_examples :successful_profile_keys_name_ids_arr do
  it '- ProfileKey check have name_ids_arr - Ok' do
    puts "In Check ProfileKey name_ids_arr: profile_id = #{profile_id} \n"
    name_ids_arr =  ProfileKey.where(profile_id: profile_id).pluck(:name_id).sort
    puts "In Check ProfileKey name_ids_arr: name_ids_arr = #{name_ids_arr.inspect} \n"
    expect(name_ids_arr).to eq(array_of_name_ids)
  end
end

