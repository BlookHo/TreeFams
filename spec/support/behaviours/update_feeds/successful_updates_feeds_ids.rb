shared_examples :successful_updates_feed_ids do
  it '- check all ids generated in UpdatesFeed rows - Ok' do
    all_ids =  UpdatesFeed.all.pluck(:id).sort
    expect(all_ids).to eq(ids_arr) # got all_ids for all rows of UpdatesFeed
    puts "In check UpdatesFeed: all_ids = #{all_ids} \n"
    expect(all_ids.size).to eq(ids_arr.size)
  end
end
