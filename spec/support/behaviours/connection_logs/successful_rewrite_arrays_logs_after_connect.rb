shared_examples :successful_rewrite_arrays_logs_after_connect do
  it '- check Arrays to rewrite & to overwrite - correct and one to one' do
    arr_rewrite =  ConnectionLog.at_current_user_connected_fields(connection_data[:current_user_id],
                                                                  connection_data[:connection_id]).
        pluck(:written).uniq
    arr_overwrite =  ConnectionLog.at_current_user_connected_fields(connection_data[:current_user_id],
                                                                    connection_data[:connection_id]).
        pluck(:overwritten).uniq
    puts "check ConnectionLog Arrays in fields: written = #{arr_rewrite}, overwritten = #{arr_overwrite} "
    expect(arr_rewrite).to eq(rewrite)
    expect(arr_overwrite).to eq(overwrite)
  end
end
