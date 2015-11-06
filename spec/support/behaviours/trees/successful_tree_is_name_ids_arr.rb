shared_examples :successful_tree_is_name_ids_arr do
  it '- Tree check have is_name_ids_arr - Ok' do
    puts "In Check Tree is_name_ids_arr: profile_id = #{profile_id} \n"
    is_name_ids_arr =  Tree.where(is_profile_id: profile_id).pluck(:is_name_id).sort
    puts "In Check Tree is_name_ids_arr: is_name_ids_arr = #{is_name_ids_arr.inspect} \n"
    expect(is_name_ids_arr).to eq(array_of_is_name_ids)
  end
end

