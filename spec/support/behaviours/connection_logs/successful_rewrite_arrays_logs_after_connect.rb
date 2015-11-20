shared_examples :successful_rewrite_arrays_logs_after_connect do
  it '- check Arrays to rewrite & to overwrite - correct and one to one' do
    arr_rewrite =  ConnectionLog.at_current_user_connected_fields(connection_data[:current_user_id],
                                                                  connection_data[:connection_id]).
        pluck(:written).uniq.sort
    arr_overwrite =  ConnectionLog.at_current_user_connected_fields(connection_data[:current_user_id],
                                                                    connection_data[:connection_id]).
        pluck(:overwritten).uniq.sort
    arr_deleted =  ConnectionLog.at_current_user_deleted_field(connection_data[:current_user_id],
                                                                    connection_data[:connection_id]).
        pluck(:written)#.uniq
    puts "check ConnectionLog Arrays in fields: deleted = #{arr_deleted}, written = #{arr_rewrite}, overwritten = #{arr_overwrite} "

    expect(arr_rewrite).to eq(rewrite)
    expect(arr_overwrite).to eq(overwrite)
    expect(arr_deleted).to eq(deleted)

  end
end
