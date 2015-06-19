shared_examples :successful_profile_data_rows_count do
  it '- check ProfileData have rows count - Ok' do
    profile_data_count =  ProfileData.all.count
    puts "in successful_profile_data_rows_count: profile_data_count = #{profile_data_count.inspect} \n"
    expect(profile_data_count).to eq(rows_qty) # got rows_qty of ProfileData
  end
end

