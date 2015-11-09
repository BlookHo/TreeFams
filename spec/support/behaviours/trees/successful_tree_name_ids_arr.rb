shared_examples :successful_tree_name_ids_arr do
  it '- Tree check have name_ids_arr - Ok' do
    puts "In Check Tree name_ids_arr: profile_id = #{profile_id} \n"
    is_name_ids_arr =  Tree.where(profile_id: profile_id).pluck(:name_id).sort
    puts "In Check Tree name_ids_arr: name_ids_arr = #{is_name_ids_arr.inspect} \n"
    expect(is_name_ids_arr).to eq(array_of_name_ids)
  end
end

