require 'rails_helper'

RSpec.describe ProfileData, :type => :model  do # , focus: true



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

    describe '- on create'  do

      it '- check ProfileData First Factory row - Ok'  do # , focus: true
        profile_data_fields = ProfileData.first.attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>1, "profile_id"=>3, "last_name"=>"Иванов",
                                           "biography"=>"Текст про Иванова", "country"=>"Россия",
                                           "city"=>"Москва", "deleted"=>0, "avatar_mongo_id"=>nil })
                                           # "birthday"=> '2015-06-18 11:28:09.738909',
                                           # "birthday"=>  'Thu, 18 Jun 2015',
      end
      it '- check ProfileData Second Factory row - Ok'  do # , focus: true
        profile_data_fields = ProfileData.second.attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>2, "profile_id"=>4, "last_name"=>"Иванов",
                                           "biography"=>"Второй Текст про Иванова", "country"=>"Россия",
                                           "city"=>"Санкт-Петербург", "deleted"=>0, "avatar_mongo_id"=>nil})
      end

      describe '- check ProfileData have rows count - Ok' do
        let(:rows_qty) {10}
        it_behaves_like :successful_profile_data_rows_count
      end

    end
  end

    describe '- Connection Method check - all ProfileData rows exists'  do # , focus: true
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

        FactoryGirl.create(:user_profile_data)             # User = 155. profile_id = 559
        FactoryGirl.create(:user_profile_data, :user_210)  # User = 210. profile_id = 22111

        FactoryGirl.create(:connected_user, :for_profile_data_5_10)    #
        FactoryGirl.create(:connected_user, :for_profile_data_6_11)    #
        FactoryGirl.create(:connected_user, :for_profile_data_7_12)    #
        FactoryGirl.create(:connected_user, :for_profile_data_8_13)    #

      end

      after {
        ProfileData.delete_all
        ProfileData.reset_pk_sequence
        ConnectedUser.delete_all
        ConnectedUser.reset_pk_sequence
        User.delete_all
        User.reset_pk_sequence
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
                                             "city"=>"Санкт-Петербург", "deleted"=>0, "avatar_mongo_id"=>nil})
          profile_data_fields = ProfileData.find(7).attributes.except('created_at','updated_at','birthday')
          expect(profile_data_fields).to eq({"id"=>7, "profile_id"=>10, "last_name"=>"Иванов",
                                             "biography"=>"", "country"=>"Белоруссия", "city"=>"",
                                             "deleted"=>1, "avatar_mongo_id"=>nil})

          profile_data_fields = ProfileData.find(4).attributes.except('created_at','updated_at','birthday')
          expect(profile_data_fields).to eq({"id"=>4, "profile_id"=>6, "last_name"=>"Иванов",
                                             "biography"=>"Текст из 11 про Иванова", "country"=>"Молдавия",
                                             "city"=>"Кишинев", "deleted"=>0, "avatar_mongo_id"=>nil})
          profile_data_fields = ProfileData.find(8).attributes.except('created_at','updated_at','birthday')
          expect(profile_data_fields).to eq({"id"=>8, "profile_id"=>11, "last_name"=>"Иванов",
                                             "biography"=>"Текст из 11 про Иванова", "country"=>"Молдавия",
                                             "city"=>"Кишинев", "deleted"=>1, "avatar_mongo_id"=>nil})

          profile_data_fields = ProfileData.find(5).attributes.except('created_at','updated_at','birthday')
          expect(profile_data_fields).to eq({"id"=>5, "profile_id"=>7, "last_name"=>"Иванов",
                                             "biography"=>"Текст из 12 ", "country"=>"Россия",
                                             "city"=>"Санкт-Петербург", "deleted"=>0, "avatar_mongo_id"=>nil})
          profile_data_fields = ProfileData.find(9).attributes.except('created_at','updated_at','birthday')
          expect(profile_data_fields).to eq({"id"=>9, "profile_id"=>12, "last_name"=>"",
                                             "biography"=>"Текст из 12 ", "country"=>"Россия",
                                             "city"=>"", "deleted"=>1, "avatar_mongo_id"=>nil})

          profile_data_fields = ProfileData.find(6).attributes.except('created_at','updated_at','birthday')
          expect(profile_data_fields).to eq({"id"=>6, "profile_id"=>8, "last_name"=>"ИвановИЧ",
                                             "biography"=>"Текст из 8 про Иванова", "country"=>"Россия",
                                             "city"=>"Санкт-Петербург", "deleted"=>0, "avatar_mongo_id"=>nil})
          profile_data_fields = ProfileData.find(10).attributes.except('created_at','updated_at','birthday')
          expect(profile_data_fields).to eq({"id"=>10, "profile_id"=>13, "last_name"=>"Иванов",
                                             "biography"=>"", "country"=>"Китай", "city"=>"",
                                             "deleted"=>1, "avatar_mongo_id"=>nil})

        end

      end

      describe '- check ProfileData have rows count - Ok' do
        let(:rows_qty) {10}
        it_behaves_like :successful_profile_data_rows_count
      end

      describe '- check ProfileData Method destroy profile data - Ok' do
        let(:connected_users_data) {{ user_id: 155, #    1,
                                      with_user_id: 210,  #        3,
                                    }}
        before { ProfileData.destroy_profile_data(connected_users_data) }
        describe '- check ProfileData have rows count After destroy - Ok' do
          let(:rows_qty) {2}
          it_behaves_like :successful_profile_data_rows_count
        end
        it "- Make proper profile_data rows after ProfileData.destroy_profile_data: " do
          puts "Destroy_profile_data Method check:\nprofiles_to_rewrite = #{profiles_to_rewrite}, profiles_to_destroy = #{profiles_to_destroy}"

        end
      end

  end


  describe '- Connection Method check - some rewrite ProfileData rows - blank'  do # , focus: true
    # create model data
    before do

      #ProfileData

      FactoryGirl.create(:profile_data)    #
      FactoryGirl.create(:profile_data, :correct2)    #

      # FactoryGirl.create(:profile_data, :connect_rewrite_1)    # profile_id = 5
      FactoryGirl.create(:profile_data, :connect_rewrite_2)    #  profile_id = 6    id = 3
      # FactoryGirl.create(:profile_data, :connect_rewrite_3)    #  profile_id = 7
      FactoryGirl.create(:profile_data, :connect_rewrite_4)    #  profile_id = 8   id = 4

      FactoryGirl.create(:profile_data, :connect_destroy_1)    #  profile_id = 10   id = 5
      FactoryGirl.create(:profile_data, :connect_destroy_2)    #  profile_id = 11   id = 6
      FactoryGirl.create(:profile_data, :connect_destroy_3)    #  profile_id = 12   id = 7
      FactoryGirl.create(:profile_data, :connect_destroy_4)    #  profile_id = 13   id = 8


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

        profile_data_fields = ProfileData.find(3).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>3, "profile_id"=>6, "last_name"=>"Иванов",
                                           "biography"=>"Текст из 11 про Иванова", "country"=>"Молдавия",
                                           "city"=>"Кишинев", "deleted"=>0, "avatar_mongo_id"=>nil})
        profile_data_fields = ProfileData.find(6).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>6, "profile_id"=>11, "last_name"=>"Иванов",
                                           "biography"=>"Текст из 11 про Иванова", "country"=>"Молдавия",
                                           "city"=>"Кишинев", "deleted"=>1, "avatar_mongo_id"=>nil})

        profile_data_fields = ProfileData.find(4).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>4, "profile_id"=>8, "last_name"=>"ИвановИЧ",
                                           "biography"=>"Текст из 8 про Иванова", "country"=>"Россия",
                                           "city"=>"Санкт-Петербург", "deleted"=>0, "avatar_mongo_id"=>nil})
        profile_data_fields = ProfileData.find(8).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>8, "profile_id"=>13, "last_name"=>"Иванов", "biography"=>"",
                                           "country"=>"Китай", "city"=>"", "deleted"=>1, "avatar_mongo_id"=>nil})

        profile_data_fields = ProfileData.find(5).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>5, "profile_id"=>10, "last_name"=>"Иванов", "biography"=>"",
                                           "country"=>"Белоруссия", "city"=>"", "deleted"=>1, "avatar_mongo_id"=>nil})
        profile_data_fields = ProfileData.find(7).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>7, "profile_id"=>12, "last_name"=>"", "biography"=>"Текст из 12 ",
                                           "country"=>"Россия", "city"=>"", "deleted"=>1, "avatar_mongo_id"=>nil})

        profile_data_fields = ProfileData.find(9).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>9, "profile_id"=>5, "last_name"=>"Иванов", "biography"=>"",
                                           "country"=>"Белоруссия", "city"=>"", "deleted"=>0, "avatar_mongo_id"=>nil})
        profile_data_fields = ProfileData.find(10).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>10, "profile_id"=>7, "last_name"=>"", "biography"=>"Текст из 12 ",
                                           "country"=>"Россия", "city"=>"", "deleted"=>0, "avatar_mongo_id"=>nil})

      end

      describe '- check ProfileData have rows count - Ok' do
        let(:rows_qty) {10}
        it_behaves_like :successful_profile_data_rows_count
      end


    end


  end


  describe '- Connection Method check - some destroy ProfileData rows - blank'  do # , focus: true
    # create model data
    before do

      #ProfileData

      FactoryGirl.create(:profile_data)    #
      FactoryGirl.create(:profile_data, :correct2)    #

      FactoryGirl.create(:profile_data, :connect_rewrite_1)    # profile_id = 5   id = 3
      FactoryGirl.create(:profile_data, :connect_rewrite_2)    #  profile_id = 6    id = 4
      FactoryGirl.create(:profile_data, :connect_rewrite_3)    #  profile_id = 7   id = 5
      FactoryGirl.create(:profile_data, :connect_rewrite_4)    #  profile_id = 8   id = 6

      # FactoryGirl.create(:profile_data, :connect_destroy_1)    #  profile_id = 10
      FactoryGirl.create(:profile_data, :connect_destroy_2)    #  profile_id = 11   id = 7
      # FactoryGirl.create(:profile_data, :connect_destroy_3)    #  profile_id = 12
      FactoryGirl.create(:profile_data, :connect_destroy_4)    #  profile_id = 13   id = 8

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
                                           "city"=>"Санкт-Петербург", "deleted"=>0, "avatar_mongo_id"=>nil})

        profile_data_fields = ProfileData.find(4).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>4, "profile_id"=>6, "last_name"=>"Иванов",
                                           "biography"=>"Текст из 11 про Иванова", "country"=>"Молдавия",
                                           "city"=>"Кишинев", "deleted"=>0, "avatar_mongo_id"=>nil})
        profile_data_fields = ProfileData.find(7).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>7, "profile_id"=>11, "last_name"=>"Иванов",
                                           "biography"=>"Текст из 11 про Иванова", "country"=>"Молдавия",
                                           "city"=>"Кишинев", "deleted"=>1, "avatar_mongo_id"=>nil})

        profile_data_fields = ProfileData.find(5).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>5, "profile_id"=>7, "last_name"=>"Иванов",
                                           "biography"=>"", "country"=>"", "city"=>"Санкт-Петербург",
                                           "deleted"=>0, "avatar_mongo_id"=>nil})

        profile_data_fields = ProfileData.find(6).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>6, "profile_id"=>8, "last_name"=>"ИвановИЧ",
                                           "biography"=>"Текст из 8 про Иванова", "country"=>"Россия",
                                           "city"=>"Санкт-Петербург", "deleted"=>0, "avatar_mongo_id"=>nil})
        profile_data_fields = ProfileData.find(8).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>8, "profile_id"=>13, "last_name"=>"Иванов",
                                           "biography"=>"", "country"=>"Китай", "city"=>"",
                                           "deleted"=>1, "avatar_mongo_id"=>nil})
      end

      describe '- check ProfileData have rows count - Ok' do
        let(:rows_qty) {8}
        it_behaves_like :successful_profile_data_rows_count
      end

    end


  end




end

