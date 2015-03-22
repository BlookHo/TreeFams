shared_examples :successful_profiles_rows_count do
  it '- check Profile have rows count - Ok' do
    profiles_count =  Profile.all.count
    puts "in successful_profiles_rows_count: profiles_count = #{profiles_count.inspect} \n"
    expect(profiles_count).to eq(rows_qty) # got rows_qty of Profile
  end
end

