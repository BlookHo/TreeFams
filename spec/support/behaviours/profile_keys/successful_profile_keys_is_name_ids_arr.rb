shared_examples :successful_profile_keys_is_name_ids_arr do
  it '- ProfileKey check have is_name_ids_arr - Ok' do
    puts "In Check ProfileKey is_name_ids_arr: profile_id = #{profile_id} \n"
    is_name_ids_arr =  ProfileKey.where(is_profile_id: profile_id).pluck(:is_name_id).sort
    puts "In Check ProfileKey is_name_ids_arr: is_name_ids_arr = #{is_name_ids_arr.inspect} \n"
    expect(is_name_ids_arr).to eq(array_of_is_name_ids)
  end
end
