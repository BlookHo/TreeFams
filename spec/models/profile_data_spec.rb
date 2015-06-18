require 'rails_helper'

RSpec.describe ProfileData, :type => :model do

  describe '- validation' do
    describe '- on create' do

      it '- check ProfileData First Factory row - Ok' , focus: true  do # , focus: true
        profile_data_fields = ProfileData.first.attributes.except('created_at','updated_at')
        expect(profile_data_fields).to eq({"id"=>1, "user_id"=>15, "found_user_id"=>35, "profile_id"=>5,
                                             "found_profile_id"=>7, "count"=>4, "found_profile_ids"=>[7, 25],
                                             "searched_profile_ids"=>[5, 52], "counts"=>[4, 4],
                                             "connection_id"=>nil, "pending_connect"=>0} )
      end

      # context '- valid log_type' do
      #   let(:log_type_row) {FactoryGirl.build(:log_type)}  #
      #   it '- saves a valid log_type_row' do
      #     puts " Model LogType validation "
      #     expect(log_type_row).to be_valid
      #   end
      # end
      #
      # context '- invalid log_type_row' do
      #   let(:bad_type_number) {FactoryGirl.build(:log_type, :type_uncorrect)}
      #   it '- 1 Dont save: - bad_type_number - less 0' do
      #     expect(bad_type_number).to_not be_valid
      #   end
      #
      #   let(:bad_table) {FactoryGirl.build(:log_type, :table_uncorrect_name)}
      #   it '- 2 Dont save: - bad_table - uncorrect string' do
      #     expect(bad_table).to_not be_valid
      #   end
      #
      #   let(:bad_table_uncorrect_data) {FactoryGirl.build(:log_type, :table_uncorrect_data)}
      #   it '- 3 Dont save: - bad_table_uncorrect_data - not string' do
      #     expect(bad_table_uncorrect_data).to_not be_valid
      #   end
      # end

    end
  end

end

