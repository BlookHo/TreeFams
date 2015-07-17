shared_examples :successful_deletion_logs_rows_count do
  it '- check DeletionLog have rows count - Ok' do
    deletion_logs_count =  DeletionLog.all.count
    puts "in successful_deletion_logs_rows_count: deletion_logs_count = #{deletion_logs_count.inspect} \n"
    expect(deletion_logs_count).to eq(rows_qty) # got rows_qty of DeletionLog
  end
end

