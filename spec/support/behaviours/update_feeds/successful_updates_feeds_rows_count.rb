shared_examples :successful_updates_feed_rows_count do
  it '- check UpdatesFeed have rows count - Ok' do
    updates_feeds_count =  UpdatesFeed.all.count
    puts "in successful_updates_feeds_rows_count: updates_feeds_count = #{updates_feeds_count.inspect} \n"
    expect(updates_feeds_count).to eq(rows_qty) # got rows_qty of UpdatesFeed
  end
end

