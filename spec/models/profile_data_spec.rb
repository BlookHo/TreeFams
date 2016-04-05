require 'rails_helper'

RSpec.describe ProfileData, :type => :model  do # , focus: true

  describe '- main faker validation'    do  # , focus: true
    it "has a valid factory" do
      puts " Model ProfileData main faker validation - has a valid factory"
      expect(FactoryGirl.create(:test_model_profile_data)).to be_valid
    end
  end

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

    describe '- on create'   do

      it '- check ProfileData First Factory row - Ok'    do # , focus: true
        profile_data_fields = ProfileData.first.attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>1, "profile_id"=>3, "last_name"=>"Иванов",
                                           "biography"=>"Текст про Иванова", "country"=>"Россия",
                                           "city"=>"Москва", "deleted"=>0, "avatar_mongo_id"=>nil,
                                           "photos"=> ["qwerty.jpeg", "ytrewq.jpeg"],
                                           "deathdate"=> "2015 03 15", "prev_last_name"=> "",
                                           "birth_place"=> "Смоленск" })
                                           # "birthday"=> '2015-06-18 11:28:09.738909',
                                           # "birthday"=>  'Thu, 18 Jun 2015',
      end
      it '- check ProfileData Second Factory row - Ok'   do # , focus: true do
        profile_data_fields = ProfileData.second.attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>2, "profile_id"=>4, "last_name"=>"Иванов",
                                           "biography"=>"Второй Текст про Иванова", "country"=>"Россия",
                                           "city"=>"Санкт-Петербург", "deleted"=>0, "avatar_mongo_id"=>nil,
                                           "photos"=> ["qwerty.jpeg", "ytrewq.jpeg", "dfdfdf3434.jjj"],
                                           "deathdate"=>"", "prev_last_name"=>"Петров", "birth_place"=>"Саратов"})
      end

      describe '- check ProfileData have rows count - Ok' do
        let(:rows_qty) {10}
        it_behaves_like :successful_profile_data_rows_count
      end

    end
  end

    describe '- Connection Method check - all ProfileData rows exists'    do # , focus: true
      # create model data
      before do

        #ProfileData

        FactoryGirl.create(:profile_data)    #
        FactoryGirl.create(:profile_data, :correct2)    #

        FactoryGirl.create(:profile_data, :connect_rewrite_1)    # id = 3
        FactoryGirl.create(:profile_data, :connect_rewrite_2)    # id = 4
        FactoryGirl.create(:profile_data, :connect_rewrite_3)    # id = 5
        FactoryGirl.create(:profile_data, :connect_rewrite_4)    # id = 6

        FactoryGirl.create(:profile_data, :connect_destroy_1)    # id = 7
        FactoryGirl.create(:profile_data, :connect_destroy_2)    # id = 8
        FactoryGirl.create(:profile_data, :connect_destroy_3)    # id = 9
        FactoryGirl.create(:profile_data, :connect_destroy_4)    # id = 10

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

      describe '- check ProfileData Method connect- Ok'     do   #  , focus: true
        before { ProfileData.connect_profiles_data(profiles_to_rewrite, profiles_to_destroy) }
        it "- Make proper profile_data rows after ProfileData.connect_profiles_data: " do
          puts "Connection Method check:\nprofiles_to_rewrite = #{profiles_to_rewrite}, profiles_to_destroy = #{profiles_to_destroy}"

          profile_data_fields = ProfileData.third.attributes.except('created_at','updated_at','birthday')
          expect(profile_data_fields).to eq({"id"=>3, "profile_id"=>5, "last_name"=>"Иванов",
                                             "biography"=>"Текст из 5 про Иванова", "country"=>"Россия",
                                             "city"=>"Санкт-Петербург", "deleted"=>0, "avatar_mongo_id"=>nil,
                                             "photos"=> ["qwerty.jpeg", "ytrewq.jpeg","qwerty.jpeg",
                                                         "ytrewq.jpeg", "dfdfdf3434.jjj"], "deathdate"=>"2015 03 15",
                                             "prev_last_name"=>nil, "birth_place"=>nil })
          profile_data_fields = ProfileData.find(7).attributes.except('created_at','updated_at','birthday')
          expect(profile_data_fields).to eq({"id"=>7, "profile_id"=>10, "last_name"=>"Иванов",
                                             "biography"=>"", "country"=>"Белоруссия", "city"=>"",
                                             "deleted"=>1, "avatar_mongo_id"=>nil,
                                             "photos"=> ["qwerty.jpeg", "ytrewq.jpeg", "dfdfdf3434.jjj"],
                                             "deathdate"=>"", "prev_last_name"=>"", "birth_place"=>"" })

          profile_data_fields = ProfileData.find(4).attributes.except('created_at','updated_at','birthday')
          expect(profile_data_fields).to eq({"id"=>4, "profile_id"=>6, "last_name"=>"Иванов",
                                             "biography"=>"Текст из 6 Ivanoff +\nТекст из 11 про Иванова",
                                             "country"=>"Молдавия",
                                             "city"=>"Кишинев", "deleted"=>0, "avatar_mongo_id"=>nil,
                                             "photos"=> ["image6_1.jpeg", "image6_2.jpeg"], "deathdate"=>nil,
                                             "prev_last_name"=>nil, "birth_place"=>nil })
          profile_data_fields = ProfileData.find(8).attributes.except('created_at','updated_at','birthday')
          expect(profile_data_fields).to eq({"id"=>8, "profile_id"=>11, "last_name"=>"Иванов",
                                             "biography"=>"Текст из 11 про Иванова", "country"=>"Молдавия",
                                             "city"=>"Кишинев", "deleted"=>1, "avatar_mongo_id"=>nil,
                                             "photos"=> ["image6_1.jpeg", "image6_2.jpeg"], "deathdate"=>"", "prev_last_name"=>"", "birth_place"=>"" })

          profile_data_fields = ProfileData.find(5).attributes.except('created_at','updated_at','birthday')
          expect(profile_data_fields).to eq({"id"=>5, "profile_id"=>7, "last_name"=>"Иванов",
                                             "biography"=>"\nТекст из 12 ", "country"=>"Россия",
                                             "city"=>"Санкт-Петербург", "deleted"=>0, "avatar_mongo_id"=>nil,
                                             "photos"=> [], "deathdate"=>nil, "prev_last_name"=>"Smith",
                                             "birth_place"=>"London" })
          profile_data_fields = ProfileData.find(9).attributes.except('created_at','updated_at','birthday')
          expect(profile_data_fields).to eq({"id"=>9, "profile_id"=>12, "last_name"=>"",
                                             "biography"=>"Текст из 12 ", "country"=>"Россия",
                                             "city"=>"", "deleted"=>1, "avatar_mongo_id"=>nil,
                                             "photos"=> [], "deathdate"=>"", "prev_last_name"=>"Smith", "birth_place"=>"" })

          profile_data_fields = ProfileData.find(6).attributes.except('created_at','updated_at','birthday')
          expect(profile_data_fields).to eq({"id"=>6, "profile_id"=>8, "last_name"=>"ИвановИЧ",
                                             "biography"=>"Текст из 8 про Иванова", "country"=>"Россия",
                                             "city"=>"Санкт-Петербург", "deleted"=>0, "avatar_mongo_id"=>nil,
                                             "photos"=> [], "deathdate"=>nil, "prev_last_name"=>"Paris", "birth_place"=>nil })
          profile_data_fields = ProfileData.find(10).attributes.except('created_at','updated_at','birthday')
          expect(profile_data_fields).to eq({"id"=>10, "profile_id"=>13, "last_name"=>"Иванов",
                                             "biography"=>nil, "country"=>"Китай", "city"=>"",
                                             "deleted"=>1, "avatar_mongo_id"=>nil,
                                             "photos"=> [], "deathdate"=>"", "prev_last_name"=>"Paris", "birth_place"=>"" })
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


  describe '- Connection Method check - some rewrite ProfileData rows - blank'     do # , focus: true
    # create model data
    before do

      #ProfileData
      # ProfileData.delete_all
      # ProfileData.reset_pk_sequence

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

      puts "Last ProfileData.id = #{ProfileData.last.id}"
      # puts "ProfileData(9).id = #{ProfileData.find(9).id}"
    end
    after {
      ProfileData.delete_all
      ProfileData.reset_pk_sequence
    }

    let(:profiles_to_rewrite) {[5,6,7,8]}
    let(:profiles_to_destroy) {[10,11,12,13]}

    describe '- check ProfileData Method connect- Ok'   do
      before { ProfileData.connect_profiles_data(profiles_to_rewrite, profiles_to_destroy) }

      describe '- First check ProfileData have rows count - Ok' do
        let(:rows_qty) {10}
        it_behaves_like :successful_profile_data_rows_count
      end

      it "- Make proper profile_data rows after ProfileData.connect_profiles_data: " do
        puts "Connection Method check:\nprofiles_to_rewrite = #{profiles_to_rewrite}, profiles_to_destroy = #{profiles_to_destroy}"

        profile_data_fields = ProfileData.find(3).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>3, "profile_id"=>6, "last_name"=>"Иванов",
                                           "biography"=>"Текст из 6 Ivanoff +\nТекст из 11 про Иванова",
                                           "country"=>"Молдавия",
                                           "city"=>"Кишинев", "deleted"=>0, "avatar_mongo_id"=>nil,
                                           "photos"=> ["image6_1.jpeg", "image6_2.jpeg"], "deathdate"=>nil, "prev_last_name"=>nil, "birth_place"=>nil })
        profile_data_fields = ProfileData.find(6).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>6, "profile_id"=>11, "last_name"=>"Иванов",
                                           "biography"=>"Текст из 11 про Иванова", "country"=>"Молдавия",
                                           "city"=>"Кишинев", "deleted"=>1, "avatar_mongo_id"=>nil,
                                           "photos"=> ["image6_1.jpeg", "image6_2.jpeg"], "deathdate"=>"", "prev_last_name"=>"", "birth_place"=>"" })

        profile_data_fields = ProfileData.find(4).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>4, "profile_id"=>8, "last_name"=>"ИвановИЧ",
                                           "biography"=>"Текст из 8 про Иванова", "country"=>"Россия",
                                           "city"=>"Санкт-Петербург", "deleted"=>0, "avatar_mongo_id"=>nil,
                                           "photos"=> [], "deathdate"=>nil, "prev_last_name"=>"Paris", "birth_place"=>nil })
        profile_data_fields = ProfileData.find(8).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>8, "profile_id"=>13, "last_name"=>"Иванов", "biography"=>nil,
                                           "country"=>"Китай", "city"=>"", "deleted"=>1, "avatar_mongo_id"=>nil,
                                           "photos"=> [], "deathdate"=>"", "prev_last_name"=>"Paris", "birth_place"=>"" })

        profile_data_fields = ProfileData.find(5).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>5, "profile_id"=>10, "last_name"=>"Иванов", "biography"=>"",
                                           "country"=>"Белоруссия", "city"=>"", "deleted"=>1, "avatar_mongo_id"=>nil,
                                           "photos"=>["qwerty.jpeg", "ytrewq.jpeg", "dfdfdf3434.jjj"],
                                           "deathdate"=>"", "prev_last_name"=>"", "birth_place"=>""})
        profile_data_fields = ProfileData.find(7).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>7, "profile_id"=>12, "last_name"=>"", "biography"=>"Текст из 12 ",
                                           "country"=>"Россия", "city"=>"", "deleted"=>1, "avatar_mongo_id"=>nil,
                                           "photos"=> [], "deathdate"=>'', "prev_last_name"=>'Smith', "birth_place"=>'' })

        profile_data_fields = ProfileData.find(9).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>9, "profile_id"=>5, "last_name"=>"Иванов", "biography"=>"",
                                           "country"=>"Белоруссия", "city"=>"", "deleted"=>0, "avatar_mongo_id"=>nil,
                                           "photos"=> ["qwerty.jpeg", "ytrewq.jpeg", "dfdfdf3434.jjj"],
                                           "deathdate"=>'', "prev_last_name"=>'', "birth_place"=>'' })
        profile_data_fields = ProfileData.find(10).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>10, "profile_id"=>7, "last_name"=>"", "biography"=>"Текст из 12 ",
                                           "country"=>"Россия", "city"=>"", "deleted"=>0, "avatar_mongo_id"=>nil,
                                           "photos"=> [], "deathdate"=>'', "prev_last_name"=>'Smith', "birth_place"=>'' })

      end

      describe '- check ProfileData have rows count - Ok' do
        let(:rows_qty) {10}
        it_behaves_like :successful_profile_data_rows_count
      end


    end


  end


  describe '- Connection Method check - some destroy ProfileData rows - blank'     do # , focus: true
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
      # puts "Last ProfileData.id = #{ProfileData.last.id}"

    end
    after {
      ProfileData.delete_all
      ProfileData.reset_pk_sequence
    }

    let(:profiles_to_rewrite) {[5,6,7,8]}
    let(:profiles_to_destroy) {[10,11,12,13]}

    describe '- check ProfileData Method connect- Ok'    do
      before { ProfileData.connect_profiles_data(profiles_to_rewrite, profiles_to_destroy) }


      it "- Make proper profile_data rows after ProfileData.connect_profiles_data: " do
        puts "Connection Method check:\nprofiles_to_rewrite = #{profiles_to_rewrite}, profiles_to_destroy = #{profiles_to_destroy}"

        profile_data_fields = ProfileData.third.attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>3, "profile_id"=>5, "last_name"=>"Иванов",
                                           "biography"=>"Текст из 5 про Иванова", "country"=>"Россия",
                                           "city"=>"Санкт-Петербург", "deleted"=>0, "avatar_mongo_id"=>nil,
                                           "photos"=>["qwerty.jpeg", "ytrewq.jpeg"], "deathdate"=>'2015 03 15',
                                           "prev_last_name"=>"", "birth_place"=>""})

        profile_data_fields = ProfileData.find(4).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>4, "profile_id"=>6, "last_name"=>"Иванов",
                                           "biography"=>"Текст из 6 Ivanoff +\nТекст из 11 про Иванова",
                                           "country"=>"Молдавия",
                                           "city"=>"Кишинев", "deleted"=>0, "avatar_mongo_id"=>nil,
                                           "photos"=>["image6_1.jpeg", "image6_2.jpeg"], "deathdate"=>nil,
                                           "prev_last_name"=>nil, "birth_place"=>nil })
        profile_data_fields = ProfileData.find(7).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>7, "profile_id"=>11, "last_name"=>"Иванов",
                                           "biography"=>"Текст из 11 про Иванова", "country"=>"Молдавия",
                                           "city"=>"Кишинев", "deleted"=>1, "avatar_mongo_id"=>nil,
                                           "photos"=>["image6_1.jpeg", "image6_2.jpeg"], "deathdate"=>"",
                                           "prev_last_name"=>"", "birth_place"=>"" })

        profile_data_fields = ProfileData.find(5).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>5, "profile_id"=>7, "last_name"=>"Иванов",
                                           "biography"=>"", "country"=>"", "city"=>"Санкт-Петербург",
                                           "deleted"=>0, "avatar_mongo_id"=>nil,  "photos"=>[], "deathdate"=>"",
                                           "prev_last_name"=>"", "birth_place"=>"London" })

        profile_data_fields = ProfileData.find(6).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>6, "profile_id"=>8, "last_name"=>"ИвановИЧ",
                                           "biography"=>"Текст из 8 про Иванова", "country"=>"Россия",
                                           "city"=>"Санкт-Петербург", "deleted"=>0, "avatar_mongo_id"=>nil,
                                           "photos"=>[], "deathdate"=>nil, "prev_last_name"=>"Paris", "birth_place"=>nil })
        profile_data_fields = ProfileData.find(8).attributes.except('created_at','updated_at','birthday')
        expect(profile_data_fields).to eq({"id"=>8, "profile_id"=>13, "last_name"=>"Иванов",
                                           "biography"=>nil, "country"=>"Китай", "city"=>"",
                                           "deleted"=>1, "avatar_mongo_id"=>nil,
                                           "photos"=>[], "deathdate"=>"", "prev_last_name"=>"Paris", "birth_place"=>""})
      end

      describe '- check ProfileData have rows count - Ok' do
        let(:rows_qty) {8}
        it_behaves_like :successful_profile_data_rows_count
      end

    end

  end


  describe '- Method check - new_weekly_profile_datas'   , focus: true   do # , focus: true
    # create model data
    let(:tree_profiles) {[3,4,5,6,7,8,10,11,12,13]}
    let(:weekly_profiles_datas) { ProfileData.new_weekly_profile_datas(tree_profiles) }

    describe '- check ProfileData Method connect- Ok'    do
      before do

        #ProfileData
        FactoryGirl.create(:profile_data)    #
        FactoryGirl.create(:profile_data, :correct2)    #

        FactoryGirl.create(:profile_data, :connect_rewrite_1)    # id = 3
        FactoryGirl.create(:profile_data, :connect_rewrite_2)    # id = 4
        FactoryGirl.create(:profile_data, :connect_rewrite_3)    # id = 5
        FactoryGirl.create(:profile_data, :connect_rewrite_4)    # id = 6

        FactoryGirl.create(:profile_data, :connect_destroy_1)    # id = 7
        FactoryGirl.create(:profile_data, :connect_destroy_2)    # id = 8
        FactoryGirl.create(:profile_data, :connect_destroy_3)    # id = 9
        FactoryGirl.create(:profile_data, :connect_destroy_4)    # id = 10

        FactoryGirl.create(:user_profile_data)             # User = 155. profile_id = 559
        FactoryGirl.create(:user_profile_data, :user_210)  # User = 210. profile_id = 22111

        FactoryGirl.create(:connected_user, :for_profile_data_5_10)    #
        FactoryGirl.create(:connected_user, :for_profile_data_6_11)    #
        FactoryGirl.create(:connected_user, :for_profile_data_7_12)    #
        FactoryGirl.create(:connected_user, :for_profile_data_8_13)    #

        # Profile
        FactoryGirl.create(:profile_one)   # 1
        FactoryGirl.create(:profile_two)   # 2
        FactoryGirl.create(:profile_three)   # 3
        FactoryGirl.create(:profile_four)   # 4
        FactoryGirl.create(:connect_profile)   # 5
        FactoryGirl.create(:connect_profile, :connect_profile_2)   # 6
        FactoryGirl.create(:connect_profile, :connect_profile_7)  # 7
        FactoryGirl.create(:connect_profile, :connect_profile_8)  # 8   tree_id = 2
        FactoryGirl.create(:connect_profile, :connect_profile_9)  # 9   tree_id = 2
        FactoryGirl.create(:connect_profile, :connect_profile_10)  # 10   tree_id = 2
        FactoryGirl.create(:connect_profile, :connect_profile_11)  # 11   tree_id = 2
        FactoryGirl.create(:connect_profile, :connect_profile_12)  # 12   tree_id = 2
        FactoryGirl.create(:connect_profile, :connect_profile_13)  # 13   tree_id = 2
      end

      after {
        ProfileData.delete_all
        ProfileData.reset_pk_sequence
        ConnectedUser.delete_all
        ConnectedUser.reset_pk_sequence
        User.delete_all
        User.reset_pk_sequence
      }

      describe '- check Profile have rows count before - Ok' do
        let(:rows_qty) {13}
        it_behaves_like :successful_profiles_rows_count
      end

      it "- Check proper weekly_profiles_datas after ProfileData.new_weekly_profile_datas: " do
        puts "new_weekly_profile_datas Method check:\n tree_profiles = #{tree_profiles}"
        puts "new_weekly_profile_datas Method check:\n weekly_profiles_datas = #{weekly_profiles_datas}"

        profile_data_fields = ProfileData.first.attributes.except('updated_at','birthday')
        puts "new_weekly_profile_datas Method check:\n profile_data_fields = #{profile_data_fields}"
        expect(weekly_profiles_datas).to eq({:new_profiles_qty=>5, :new_profiles_male=>3,
                                           :new_profiles_female=>2, :new_profiles_ids=>[3, 4, 5, 11, 13]
                                          })
      end


    end

  end

end
