shared_examples :success_search_service_count do
  it '- check SearchServiceLogs have rows count - Ok' do
    search_service_count =  SearchServiceLogs.all.count
    puts "in successful_search_results_rows_count: search_service_count = #{search_service_count.inspect} \n"
    expect(search_service_count).to eq(rows_qty) # got rows_qty of SearchServiceLogs
  end
end

