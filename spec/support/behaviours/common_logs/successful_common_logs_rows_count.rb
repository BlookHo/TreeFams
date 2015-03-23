shared_examples :successful_common_logs_rows_count do
  it '- check CommonLog have rows count - Ok' do
    common_logs_count =  CommonLog.all.count
    puts "in successful_common_logs_rows_count: common_logs_count = #{common_logs_count.inspect} \n"
    expect(common_logs_count).to eq(rows_qty) # got rows_qty of CommonLog
  end
end

