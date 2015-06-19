require 'rails_helper'

RSpec.describe ProfileData, :type => :model do



  describe '- validation'    do
    before {

    FactoryGirl.create(:profile_data)    #
    FactoryGirl.create(:profile_data, :correct2)    #

    FactoryGirl.create(:profile_data, :connect_rewrite_1)    #
    FactoryGirl.create(:profile_data, :connect_rewrite_2)    #
    FactoryGirl.create(:profile_data, :connect_rewrite_3)    #
    FactoryGirl.create(:profile_data, :connect_rewrite_4)    #

    FactoryGirl.create(:profile_data, :connect_destroy_1)    #
    FactoryGirl.create(:profile_data, :connect_destroy_2)    #
    FactoryGirl.create(:profile_data, :connect_destroy_3)    #
    FactoryGirl.create(:profile_data, :connect_destroy_4)    #
    }

    after {
      ProfileData.delete_all
      ProfileData.reset_pk_sequence
    }

    describe '- on create' do

      it '- check ProfileData First Factory row - Ok'  do # , focus: true
        profile_data_fields = ProfileData.first.attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>1, "profile_id"=>3, "last_name"=>"Иванов",
                                           "biography"=>"Текст про Иванова", "country"=>"Россия",
                                           "city"=>"Москва", "deleted"=>0 })
                                           # "birthday"=> '2015-06-18 11:28:09.738909',
                                           # "birthday"=>  'Thu, 18 Jun 2015',
      end
      it '- check ProfileData Second Factory row - Ok'  do # , focus: true
        profile_data_fields = ProfileData.second.attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>2, "profile_id"=>4, "last_name"=>"Иванов",
                                           "biography"=>"Второй Текст про Иванова", "country"=>"Россия",
                                           "city"=>"Санкт-Петербург", "deleted"=>0})
      end

      describe '- check ProfileData have rows count - Ok' do
        let(:rows_qty) {10}
        it_behaves_like :successful_profile_data_rows_count
      end

    end
  end

    describe '- Connection Method check'  do # , focus: true
      # create model data
      before do

        #ProfileData

        FactoryGirl.create(:profile_data)    #
        FactoryGirl.create(:profile_data, :correct2)    #

        FactoryGirl.create(:profile_data, :connect_rewrite_1)    #
        FactoryGirl.create(:profile_data, :connect_rewrite_2)    #
        FactoryGirl.create(:profile_data, :connect_rewrite_3)    #
        FactoryGirl.create(:profile_data, :connect_rewrite_4)    #

        FactoryGirl.create(:profile_data, :connect_destroy_1)    #
        FactoryGirl.create(:profile_data, :connect_destroy_2)    #
        FactoryGirl.create(:profile_data, :connect_destroy_3)    #
        FactoryGirl.create(:profile_data, :connect_destroy_4)    #


      end
      after {
        ProfileData.delete_all
        ProfileData.reset_pk_sequence
      }

      let(:profiles_to_rewrite) {[5,6,7,8]}
      let(:profiles_to_destroy) {[10,11,12,13]}

      describe '- check ProfileData Method connect- Ok' do
        before { ProfileData.connect_profiles_data(profiles_to_rewrite, profiles_to_destroy) }
        it "- Make proper profile_data rows after ProfileData.connect_profiles_data: " do
          puts "Connection Method check:\nprofiles_to_rewrite = #{profiles_to_rewrite}, profiles_to_destroy = #{profiles_to_destroy}"

          profile_data_fields = ProfileData.third.attributes.except('created_at','updated_at','birthday')
          expect(profile_data_fields).to eq({"id"=>3, "profile_id"=>5, "last_name"=>"Иванов",
                                             "biography"=>"Текст из 5 про Иванова", "country"=>"Россия",
                                             "city"=>"Санкт-Петербург", "deleted"=>0})
          profile_data_fields = ProfileData.find(7).attributes.except('created_at','updated_at','birthday')
          expect(profile_data_fields).to eq({"id"=>7, "profile_id"=>10, "last_name"=>"Иванов",
                                             "biography"=>"", "country"=>"Белоруссия", "city"=>"", "deleted"=>1})

          profile_data_fields = ProfileData.find(4).attributes.except('created_at','updated_at','birthday')
          expect(profile_data_fields).to eq({"id"=>4, "profile_id"=>6, "last_name"=>"Иванов",
                                             "biography"=>"Текст из 11 про Иванова", "country"=>"Молдавия",
                                             "city"=>"Кишинев", "deleted"=>0})
          profile_data_fields = ProfileData.find(8).attributes.except('created_at','updated_at','birthday')
          expect(profile_data_fields).to eq({"id"=>8, "profile_id"=>11, "last_name"=>"Иванов",
                                             "biography"=>"Текст из 11 про Иванова", "country"=>"Молдавия",
                                             "city"=>"Кишинев", "deleted"=>1})

          profile_data_fields = ProfileData.find(5).attributes.except('created_at','updated_at','birthday')
          expect(profile_data_fields).to eq({"id"=>5, "profile_id"=>7, "last_name"=>"Иванов",
                                             "biography"=>"Текст из 12 ", "country"=>"Россия",
                                             "city"=>"Санкт-Петербург", "deleted"=>0})
          profile_data_fields = ProfileData.find(9).attributes.except('created_at','updated_at','birthday')
          expect(profile_data_fields).to eq({"id"=>9, "profile_id"=>12, "last_name"=>"",
                                             "biography"=>"Текст из 12 ", "country"=>"Россия",
                                             "city"=>"", "deleted"=>1})

          profile_data_fields = ProfileData.find(6).attributes.except('created_at','updated_at','birthday')
          expect(profile_data_fields).to eq({"id"=>6, "profile_id"=>8, "last_name"=>"ИвановИЧ",
                                             "biography"=>"Текст из 8 про Иванова", "country"=>"Россия",
                                             "city"=>"Санкт-Петербург", "deleted"=>0})
          profile_data_fields = ProfileData.find(10).attributes.except('created_at','updated_at','birthday')
          expect(profile_data_fields).to eq({"id"=>10, "profile_id"=>13, "last_name"=>"Иванов",
                                             "biography"=>"", "country"=>"Китай", "city"=>"", "deleted"=>1})

        end

      end

      describe '- check ProfileData have rows count - Ok' do
        let(:rows_qty) {10}
        it_behaves_like :successful_profile_data_rows_count
      end

  end

end

