shared_examples :successful_weafam_stats_rows_count do
  it '- check WeafamStat have rows count - Ok' do
    weafam_stats_count =  WeafamStat.all.count
    puts "in successful_weafam_stats_rows_count: weafam_stats_count = #{weafam_stats_count.inspect} \n"
    expect(weafam_stats_count).to eq(rows_qty) # got rows_qty of WeafamStat
  end
end

