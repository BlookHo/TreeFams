shared_examples :successful_search_results_rows_count do
  it '- check SearchResults have rows count - Ok' do
    search_results_count =  SearchResults.all.count
    puts "in successful_search_results_rows_count: search_results_count = #{search_results_count.inspect} \n"
    expect(search_results_count).to eq(rows_qty) # got rows_qty of SearchResults
  end
end

