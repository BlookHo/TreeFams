shared_examples :successful_tree_name_ids_arr do
  it '- Tree check have name_ids_arr - Ok' do
    puts "In Check Tree name_ids_arr: profile_id = #{profile_id} \n"
    name_ids_arr = []
    tree_rows = Tree.where(profile_id: profile_id)

    tree_rows.each do |one_row|
      name_ids_arr << one_row.name_id
    end
    name_ids_arr
    puts "In Check Tree name_ids_arr:  #{name_ids_arr} \n"

    expect(name_ids_arr).to eq(array_of_name_ids)
  end
end

