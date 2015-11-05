shared_examples :successful_profile_keys_relation_ids do
  it '- check all relations generated in ProfileKey rows - Ok' do
    all_relations_all =  ProfileKey.all.pluck(:relation_id).sort
    all_relations =  ProfileKey.where(deleted: 0).pluck(:relation_id).sort
    # puts "After ADD Wife Check ProfileKey \n"
    # puts "In check ProfileKey: all_relations = #{all_relations.inspect} \n"
    expect(all_relations_all).to eq(relations_ids_arr_all) # got relations array of ProfileKey
    expect(all_relations_all.size).to eq(relations_arr_all_size)
    expect(all_relations).to eq(relations_ids_arr) # got relations array of ProfileKey
    puts "In check ProfileKey: relations_arr_size = #{all_relations.size} \n"
    expect(all_relations.size).to eq(relations_arr_size)
  end
end
