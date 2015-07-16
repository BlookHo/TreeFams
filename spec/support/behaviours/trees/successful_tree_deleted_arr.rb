# shared_examples :successful_profiles_deleted_arr do
#   it '- Tree check have rows count & ids before - Ok' do
#     puts "In Check Profiles deleted: opposite_profiles_arr = #{opposite_profiles_arr} \n"
#     trees_deleted_arr = []
#     opposite_profiles_arr.each do |one_row|
#       profiles_deleted_arr << Tree.find(one_row).deleted
#     end
#     profiles_deleted_arr
#     puts "In Check Profiles deleted: profiles_deleted_arr = #{profiles_deleted_arr} \n"
#
#     expect(trees_deleted_arr).to eq(profiles_deleted) # array of deleted Profiles
#   end
# end
#

