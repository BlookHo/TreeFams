shared_examples :successful_profile_keys_rows_count do
  it '- check ProfileKey have rows count - Ok' do
    profile_keys_count =  ProfileKey.all.count
    puts "in successful_profile_keys_rows_count: profile_keys_count = #{profile_keys_count.inspect} \n"
    expect(profile_keys_count).to eq(rows_qty) # got rows_qty of ProfileKey
  end
end

