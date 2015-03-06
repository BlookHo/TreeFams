require 'rails_helper'

# describe ProfileKey do
RSpec.describe ProfileKey, :type => :model do

  describe '- validation' do
    describe '- on create' do

      context '- valid profile_key' do
        let(:profilekey_row) {FactoryGirl.build(:profile_key)}  #
        it '- saves a valid profilekey_row' do
          puts " Model ProfileKey validation "
          expect(profilekey_row).to be_valid
        end

        let(:good_profilekey_row_big) {FactoryGirl.build(:profile_key, :big_IDs)}
        it '- 2 Saves a valid profilekey_row - big IDs' do
          expect(good_profilekey_row_big).to be_valid
        end
      end

      context '- invalid profile_key' do
        let(:bad_user_id) {FactoryGirl.build(:profile_key, :user_less_zero)}
        it '- 1 Dont save: - bad_user_id - less 0' do
          expect(bad_user_id).to_not be_valid
        end

        let(:bad_profile_id) {FactoryGirl.build(:profile_key, :profile_id_less_zero)}
        it '- 2 Dont save: - bad_profile_id - less 0' do
          expect(bad_profile_id).to_not be_valid
        end

        let(:bad_name_id) {FactoryGirl.build(:profile_key, :name_id_less_zero)}
        it '- 3 Dont save: - bad_name_id - less 0' do
          expect(bad_name_id).to_not be_valid
        end

        let(:bad_relation_id_less_zero) {FactoryGirl.build(:profile_key, :relation_id_less_zero)}
        it '- 4 Dont save: - bad_relation_id - less 0' do
          expect(bad_relation_id_less_zero).to_not be_valid
        end

        let(:bad_is_profile_id) {FactoryGirl.build(:profile_key, :is_profile_id_equ_zero)}
        it '- 5 Dont save: - bad_is_profile_id - == 0' do
          expect(bad_is_profile_id).to_not be_valid
        end

        let(:bad_is_name_id) {FactoryGirl.build(:profile_key, :is_name_id_equ_zero)}
        it '- 6 Dont save: - bad_is_name_id - == 0' do
          expect(bad_is_name_id).to_not be_valid
        end

        let(:bad_relation_id_wrong_number) {FactoryGirl.build(:profile_key, :relation_wrong)}
        it '- 7 Dont save: - bad_relation_id_wrong_number - == 9' do
          expect(bad_relation_id_wrong_number).to_not be_valid
        end

        let(:bad_profiles_wrong_equal) {FactoryGirl.build(:profile_key, :profiles_wrong_equal)}
        it '- 8 Dont save: - bad_profiles_wrong_equal - == ' do
          expect(bad_profiles_wrong_equal).to_not be_valid
        end

        let(:bad_profile_non_integer) {FactoryGirl.build(:profile_key, :profile_non_integer)}
        it '- 9 Dont save: - bad_profile_non_integer - == 6.77 ' do
          expect(bad_profile_non_integer).to_not be_valid
        end
      end

    end
  end

  describe '- CHECK ProfileKey Model methods' do


    let(:base_profile_85) { create(:profile, :add_profile_85) }  # User = 9. Tree = 9. profile_id = 85

    # create model data
    before {

      # User
      FactoryGirl.create(:user)  # User = 1. Tree = 1. profile_id = 63
      FactoryGirl.create(:user, :user_2 )  # User = 2 . Tree = 10. profile_id = 66
      FactoryGirl.create(:user, :user_3 )  # User = 3 . Tree = 10. profile_id = 333
      FactoryGirl.create(:user, :user_4 )  # User = 4 . Tree = 10. profile_id = 444
      FactoryGirl.create(:user, :user_5 )  # User = 5 . Tree = 10. profile_id = 555
      FactoryGirl.create(:user, :user_6 )  # User = 6 . Tree = 10. profile_id = 666
      FactoryGirl.create(:user, :user_7 )  # User = 7 . Tree = 10. profile_id = 777
      FactoryGirl.create(:user, :user_8 )  # User = 8 . Tree = 10. profile_id = 888
      # FactoryGirl.create(:user, :user_9 )  # User = 9 . Tree = 9 . profile_id = 85
      # FactoryGirl.create(:user, :user_10 )  # User = 10. Tree = 10. profile_id = 93

      puts "before All: User.first = #{User.first.id} \n" # id = 10
      puts "before All: User.last.id = #{User.last.id} \n" # id = 10
      # puts "before All: User.find(10).profile_id = #{User.find(10).profile_id} \n" # id = 10

      FactoryGirl.create(:connected_user, :correct)      # 1  2
      FactoryGirl.create(:connected_user, :correct_3_4)  # 3  4
      puts "before All: ConnectedUser.count = #{ConnectedUser.all.count} \n" # 2 rows

      # Profile
      # FactoryGirl.create(:profile, :add_profile_85) # user_9  # before

      # FactoryGirl.create(:profile, :add_profile_86)   # 86
      # FactoryGirl.create(:profile, :add_profile_87)   # 87
      FactoryGirl.create(:profile, :add_profile_88) # before
      FactoryGirl.create(:profile, :add_profile_89) # before
      FactoryGirl.create(:profile, :add_profile_90) # before
      FactoryGirl.create(:profile, :add_profile_91) # before
      # FactoryGirl.create(:profile, :add_profile_92)   # 92

      FactoryGirl.create(:profile, :profile_84) # before
      puts "before All: Profile.find(84).user_id = #{Profile.find(84).user_id} \n"  # id =
      puts "before All: Profile.find(84).sex_id = #{Profile.find(84).sex_id} \n"  # id =
      puts "before All: Profile.find(84).id = #{Profile.find(84).id} \n"  # id =




      # FactoryGirl.create(:profile, :add_profile_93) # user_10 # before
      # FactoryGirl.create(:profile, :add_profile_94)
      # FactoryGirl.create(:profile, :add_profile_95)
      # FactoryGirl.create(:profile, :add_profile_96) # before
      # FactoryGirl.create(:profile, :add_profile_97) # before
      # FactoryGirl.create(:profile, :add_profile_98) # before
      # FactoryGirl.create(:profile, :add_profile_99) # before
      # FactoryGirl.create(:profile, :add_profile_100)
      puts "before All: base_profile_85.id = #{base_profile_85.id} \n"  # id =
      puts "before All: base_profile_85.user_id = #{base_profile_85.user_id} \n"  # id =
      puts "before All: base_profile_85.name_id = #{base_profile_85.name_id} \n"  # id =
      puts "before All: base_profile_85.sex_id = #{base_profile_85.sex_id} \n"  # id =
      puts "before All: base_profile_85.tree_id = #{base_profile_85.tree_id} \n"  # id =
      puts "before All: Profile.find(89).sex_id = #{Profile.find(89).sex_id} \n"  # id =
      puts "before All: Profile.first.id = #{Profile.first.id} \n"  # id =
      puts "before All: Profile.last.id = #{Profile.last.id} \n"  # id =
      puts "before All: Profile.last.name_id = #{Profile.last.name_id} \n"  # name_id = 90
      puts "before All: Profile.last.sex_id = #{Profile.last.sex_id} \n"  # name_id = 90
      puts "before All: Profile.count = #{Profile.all.count} \n" # 2

      # Tree
      # FactoryGirl.create(:tree, :add_tree9_1)   # 86
      # FactoryGirl.create(:tree, :add_tree9_2)   # 87
      FactoryGirl.create(:tree, :add_tree9_3) # before
      FactoryGirl.create(:tree, :add_tree9_4) # before
      FactoryGirl.create(:tree, :add_tree9_5) # before
      FactoryGirl.create(:tree, :add_tree9_6) # before
      # FactoryGirl.create(:tree, :add_tree9_7)   # 92

      # FactoryGirl.create(:tree, :add_tree10_1)
      # FactoryGirl.create(:tree, :add_tree10_2)
      # FactoryGirl.create(:tree, :add_tree10_3) # before
      # FactoryGirl.create(:tree, :add_tree10_4) # before
      # FactoryGirl.create(:tree, :add_tree10_5) # before
      # FactoryGirl.create(:tree, :add_tree10_6) # before
      # FactoryGirl.create(:tree, :add_tree10_7)
      # puts "before All: Tree.find(4).profile_id = #{Tree.find(4).profile_id.inspect} \n"  # id = 64
      puts "before All: Tree.last.is_profile_id = #{Tree.last.is_profile_id} \n"  # is_profile_id = 84
      puts "before All: Tree.last.is_sex_id = #{Tree.last.is_sex_id} \n"  # is_sex_id = 84
      puts "before All: Tree.count = #{Tree.all.count} \n" # 20


      #Profile_Key
      # Before Add new Profile  -  tree #9 Petr
      # FactoryGirl.create(:profile_key, :profile_key9_add_1)   # 86
      # FactoryGirl.create(:profile_key, :profile_key9_add_2)   # 86
      # FactoryGirl.create(:profile_key, :profile_key9_add_3)   # 87
      # FactoryGirl.create(:profile_key, :profile_key9_add_4)   # 87
      # FactoryGirl.create(:profile_key, :profile_key9_add_5)   # 86, 87
      # FactoryGirl.create(:profile_key, :profile_key9_add_6)   # 86, 87
      FactoryGirl.create(:profile_key, :profile_key9_add_7) # before
      FactoryGirl.create(:profile_key, :profile_key9_add_8) # before
      # FactoryGirl.create(:profile_key, :profile_key9_add_9)   # 86
      # FactoryGirl.create(:profile_key, :profile_key9_add_10)   # 86
      # FactoryGirl.create(:profile_key, :profile_key9_add_11)   # 87
      # FactoryGirl.create(:profile_key, :profile_key9_add_12)   # 87
      FactoryGirl.create(:profile_key, :profile_key9_add_13) # before
      FactoryGirl.create(:profile_key, :profile_key9_add_14) # before
      # FactoryGirl.create(:profile_key, :profile_key9_add_15)   # 86
      # FactoryGirl.create(:profile_key, :profile_key9_add_16)   # 86
      # FactoryGirl.create(:profile_key, :profile_key9_add_17)   # 87
      # FactoryGirl.create(:profile_key, :profile_key9_add_18)   # 87
      FactoryGirl.create(:profile_key, :profile_key9_add_19) # before
      FactoryGirl.create(:profile_key, :profile_key9_add_20) # before
      FactoryGirl.create(:profile_key, :profile_key9_add_21) # before
      FactoryGirl.create(:profile_key, :profile_key9_add_22) # before
      # FactoryGirl.create(:profile_key, :profile_key9_add_23)   # 86
      # FactoryGirl.create(:profile_key, :profile_key9_add_24)   # 86
      # FactoryGirl.create(:profile_key, :profile_key9_add_25)   # 87
      # FactoryGirl.create(:profile_key, :profile_key9_add_26)   # 87
      FactoryGirl.create(:profile_key, :profile_key9_add_27) # before
      FactoryGirl.create(:profile_key, :profile_key9_add_28) # before
      FactoryGirl.create(:profile_key, :profile_key9_add_29) # before
      FactoryGirl.create(:profile_key, :profile_key9_add_30) # before
      FactoryGirl.create(:profile_key, :profile_key9_add_31) # before
      FactoryGirl.create(:profile_key, :profile_key9_add_32) # before
      FactoryGirl.create(:profile_key, :profile_key9_add_33) # before
      FactoryGirl.create(:profile_key, :profile_key9_add_34) # before
      # FactoryGirl.create(:profile_key, :profile_key9_add_35)   # 86
      # FactoryGirl.create(:profile_key, :profile_key9_add_36)   # 86
      # FactoryGirl.create(:profile_key, :profile_key9_add_37)   # 87
      # FactoryGirl.create(:profile_key, :profile_key9_add_38)   # 87
      FactoryGirl.create(:profile_key, :profile_key9_add_39) # before
      FactoryGirl.create(:profile_key, :profile_key9_add_40) # before
      FactoryGirl.create(:profile_key, :profile_key9_add_41) # before
      FactoryGirl.create(:profile_key, :profile_key9_add_42) # before
      # FactoryGirl.create(:profile_key, :profile_key9_add_43)   # 92
      # FactoryGirl.create(:profile_key, :profile_key9_add_44)   # 92
      # FactoryGirl.create(:profile_key, :profile_key9_add_45)   # 92
      # FactoryGirl.create(:profile_key, :profile_key9_add_46)   # 92
      # FactoryGirl.create(:profile_key, :profile_key9_add_47)   # 92
      # FactoryGirl.create(:profile_key, :profile_key9_add_48)   # 92
      # FactoryGirl.create(:profile_key, :profile_key9_add_49)   # 92 86
      # FactoryGirl.create(:profile_key, :profile_key9_add_50)   # 92 86
      # FactoryGirl.create(:profile_key, :profile_key9_add_51)   # 92 87
      # FactoryGirl.create(:profile_key, :profile_key9_add_52)   # 92 87
      puts "before All: ProfileKey.last.user_id = #{ProfileKey.last.user_id} \n"  # user_id = 1
      puts "before All: ProfileKey.last.name_id = #{ProfileKey.last.is_name_id} \n"  # name_id = 187
      puts "before All: ProfileKey.count = #{ProfileKey.all.count} \n" # 112

      #Name -  # before
      FactoryGirl.create(:name, :name_28)    # Алексей
      FactoryGirl.create(:name, :name_48)    # Анна
      FactoryGirl.create(:name, :name_147)   # Дарья
      FactoryGirl.create(:name, :name_343)   # Николай
      FactoryGirl.create(:name, :name_345)   # Нина
      FactoryGirl.create(:name, :name_370)   # Петр
      FactoryGirl.create(:name, :name_412)   # Светлана
      FactoryGirl.create(:name, :name_419)   # Семен
      FactoryGirl.create(:name, :name_446)   # Таисия
      FactoryGirl.create(:name, :name_465)   # Федор
      puts "before All: Name.first.name = #{Name.first.name} \n"  # Алексей

    }


    after {
      User.delete_all
      User.reset_pk_sequence
      ConnectedUser.delete_all
      ConnectedUser.reset_pk_sequence
      Tree.delete_all
      Tree.reset_pk_sequence
      Profile.delete_all
      Profile.reset_pk_sequence
      ProfileKey.delete_all
      ProfileKey.reset_pk_sequence
      # WeafamSetting.delete_all
      # WeafamSetting.reset_pk_sequence
      Name.delete_all
      Name.reset_pk_sequence
      # SimilarsFound.delete_all
      # SimilarsFound.reset_pk_sequence
    }

    # create parameters
    let(:current_user_9) { create(:user, :user_9) }  # User = 9. Tree = 9. profile_id = 85
    let(:currentuser_id) {current_user_9.id}  # id = 9
    let(:connected_users) { current_user_9.get_connected_users }  # [9]

    context '- before actions - check connected_users' do

      it "- Return proper connected_users Array result for current_user_id = 9" do
        puts "Check ProfileKey Model methods \n"
        puts "Before All - connected_users created \n"  #
        puts "Let created: currentuser_id = #{currentuser_id}, current_user_9.profile_id = #{current_user_9.profile_id} \n"
        # currentuser_id = 9  profile_id = 85
        puts "Let created: connected_users = #{connected_users} \n"   # [9]
        expect(connected_users).to be_a_kind_of(Array)
      end
      it "- Return proper connected_users Array result for current_user_id = 1" do
        puts "Let created: connected_users = #{connected_users} \n"   # [9]
        expect(connected_users).to eq([9])
      end
    end

    # from home_controller.rb#index
    describe 'GET #add_new_profile *' do

      describe '- Base Profile - is Male ' do
        describe '- Added Father - new profile - ' do

           before {
            # Tree
            FactoryGirl.create(:tree, :add_tree9_2)   # 87
            FactoryGirl.create(:tree, :add_tree9_7)   # 92

            # Profile
            FactoryGirl.create(:profile, :add_profile_87)   # 87
            FactoryGirl.create(:profile, :add_profile_92)   # 92

            #Profile_Key
            # Before Add new Profile  -  tree #9 Petr
            # FactoryGirl.create(:profile_key, :profile_key9_add_1)   # 86
            # FactoryGirl.create(:profile_key, :profile_key9_add_2)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_3)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_4)   # 87
            # FactoryGirl.create(:profile_key, :profile_key9_add_5)   # 86, 87
            # FactoryGirl.create(:profile_key, :profile_key9_add_6)   # 86, 87
            # FactoryGirl.create(:profile_key, :profile_key9_add_9)   # 86
            # FactoryGirl.create(:profile_key, :profile_key9_add_10)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_11)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_12)   # 87
            # FactoryGirl.create(:profile_key, :profile_key9_add_15)   # 86
            # FactoryGirl.create(:profile_key, :profile_key9_add_16)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_17)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_18)   # 87
            # FactoryGirl.create(:profile_key, :profile_key9_add_23)   # 86
            # FactoryGirl.create(:profile_key, :profile_key9_add_24)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_25)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_26)   # 87
            # FactoryGirl.create(:profile_key, :profile_key9_add_35)   # 86
            # FactoryGirl.create(:profile_key, :profile_key9_add_36)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_37)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_38)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_43)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_44)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_45)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_46)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_47)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_48)   # 92
            # FactoryGirl.create(:profile_key, :profile_key9_add_49)   # 92 86
            # FactoryGirl.create(:profile_key, :profile_key9_add_50)   # 92 86
            FactoryGirl.create(:profile_key, :profile_key9_add_51)   # 92 87
            FactoryGirl.create(:profile_key, :profile_key9_add_52)   # 92 87

          }
          context '- before action <add_new_profile> - check created data' do
            puts "Before action - data created \n"  #
            it "- Return proper connected_users Array result for current_user_id = 1" do
              puts "Let created: currentuser_id = #{currentuser_id}, current_user_9.profile_id = #{current_user_9.profile_id} \n"
              puts "Let created: connected_users = #{connected_users} \n"   # [9]
              expect(connected_users).to eq([9])
            end
          end

           let(:base_profile) {base_profile_85}
           # let(:base_sex_id) {Profile.find(base_profile.id).sex_id}
           let(:base_sex_id) {base_profile.sex_id}
           let(:new_profile) {81}
           let(:new_relation_id) {70}
           let(:exclusions_hash) {81}
           let(:tree_ids) {connected_users}

           context '- before action <add_new_profile> - check input params values ' do
             it "- check: base_profile" do
               puts "check base_profile_85.sex_id: = #{base_profile_85.sex_id} \n"  # 1
               puts "check base_profile.id: = #{base_profile.id} \n"  # 1
               puts "check base_profile.sex_id: = #{base_profile.sex_id} \n"  # 1
               expect(base_profile.id).to eq(85)
             end
             it "- check: base_sex_id, base_profile, new_profile, new_relation_id, exclusions_hash: nil,
                            tree_ids: tree_ids" do
               # get {add_new_profile(base_sex_id, base_profile,
               #                 new_profile, new_relation_id,
               #                 exclusions_hash: nil,
               #                 tree_ids: tree_ids)     }
               puts "check base_sex_id: = #{base_sex_id} \n"  # 1
               # expect(base_sex_id).to eq([])
             end
              it "- check: base_sex_id, base_profile, new_profile, new_relation_id, exclusions_hash: nil,
                            tree_ids: tree_ids" do
               # get {add_new_profile(base_sex_id, base_profile,
               #                 new_profile, new_relation_id,
               #                 exclusions_hash: nil,
               #                 tree_ids: tree_ids)     }
               # puts "check base_sex_id: = #{base_sex_id} \n"  # 1
               # expect(:base_sex_id).to eq([])
             end

           end

          context '- After action <internal_similars_search>: check results got' do
            # before {get :internal_similars_search}
            #
            # it '- tree_info: tree_is_profiles, tree_profiles_amount - Ok' do
            #   # puts "In check results: tree_info \n"
            #   expect(assigns(:tree_info)).to include(:tree_is_profiles => [63, 64, 65, 66, 67, 68, 69, 70, 78, 79, 80, 81, 82, 83, 84])
            #   expect(assigns(:tree_info)).to include(:tree_profiles_amount => 15)
            #   expect(assigns(:tree_info)).to include(:users_profiles_ids=>[63, 66])
            # end
            #
            # it '- new_sims - Ok' do
            #   expect(assigns(:new_sims)).to eq("New sims")
            #   # puts "In check results: new_sims \n"
            # end
            #
            # it '- log_connection_id - Ok' do
            #   # puts "In check results: log_connection_id \n"
            #   expect(assigns(:log_connection_id)).to eq([])
            # end
            #
            # let(:similars_got) { assigns(:similars) }
            # let(:similars_first_pair) { similars_got[0] }
            # let(:similars_second_pair) { similars_got[1] }
            # it '- similars_first_pair - Ok' do
            #   # puts "In check results: similars_got = #{similars_first_pair} \n"
            #   first_pair_profile_ids = [similars_first_pair[:first_profile_id], similars_first_pair[:second_profile_id]].sort
            #   expect(first_pair_profile_ids).to eq([70, 81])
            #   # puts "In check results: first_pair_profile_ids = #{first_pair_profile_ids} \n"
            # end

          end

          context '- After action <internal_similars_search>: check SimilarsFound' do
            # it '- in SimilarsFound stored 2 rows of good sims pairs & first row - Ok' do
            #   get :internal_similars_search
            #   sims_count =  SimilarsFound.all.count
            #   puts "Check #internal_similars_search check SimilarsFound\n"
            #   # puts "In check SimilarsFound count rows: rows sims_count = #{sims_count.inspect} \n"
            #   expect(sims_count).to eq(2) # got 2 rows of similars
            #   first_row = SimilarsFound.first
            #   first_pair_profile_ids = [first_row.first_profile_id, first_row.second_profile_id].sort
            #   expect(first_pair_profile_ids).to eq([70, 81])
            #   # puts "In check SimilarsFound rows:  first_row = #{first_row.inspect} \n"
            #   # puts "In check SimilarsFound rows:  first_row.second_profile_id = #{first_row.second_profile_id.inspect} \n"
            #   second_row = SimilarsFound.second
            #   second_pair_profile_ids = [second_row.first_profile_id, second_row.second_profile_id].sort
            #   expect(second_pair_profile_ids).to eq([79, 82])
            #   # puts "In check SimilarsFound rows:  second_row = #{second_row.inspect} \n"
            #   # puts "In check SimilarsFound rows:  second_row.second_profile_id = #{second_row.second_profile_id.inspect} \n"
            # end
          end

        end

        describe '- Added Mother - ' do

          context '- after action <internal_similars_search> - check render_template & response status' do
            # subject { get :internal_similars_search }
            # it "- render_template internal_similars_search" do
            #   puts "Check #internal_similars_search\n"
            #   # puts "In render_template :  currentuser_id = #{currentuser_id} \n"
            #   expect(subject).to render_template :internal_similars_search
            # end
            # it '- responds with 200' do
            #   # puts "In responds with 200:  currentuser_id = #{currentuser_id} \n"
            #   expect(response.status).to eq(200)
            # end
            # it '- no responds with 401' do
            #   # puts "In no responds with 401:  currentuser_id = #{currentuser_id} \n"
            #   expect(response.status).to_not eq(401)
            # end
          end

          context '- In action <internal_similars_search> - check instances  ' do
            # it "- got values: log_connection_id, connected_users, current_user_id" do
            #   get :internal_similars_search
            #   # puts "In check instances :  currentuser_id = #{currentuser_id} \n"  # 1
            #   expect(assigns(:log_connection_id)).to eq([])
            #   expect(assigns(:connected_users)).to eq([1,2])
            #   expect(assigns(:current_user_id)).to eq(1)
            # end
          end

          context '- After action <internal_similars_search>: check results got' do
            # before {get :internal_similars_search}
            #
            # it '- tree_info: tree_is_profiles, tree_profiles_amount - Ok' do
            #   # puts "In check results: tree_info \n"
            #   expect(assigns(:tree_info)).to include(:tree_is_profiles => [63, 64, 65, 66, 67, 68, 69, 70, 78, 79, 80, 81, 82, 83, 84])
            #   expect(assigns(:tree_info)).to include(:tree_profiles_amount => 15)
            #   expect(assigns(:tree_info)).to include(:users_profiles_ids=>[63, 66])
            # end
            #
            # it '- new_sims - Ok' do
            #   expect(assigns(:new_sims)).to eq("New sims")
            #   # puts "In check results: new_sims \n"
            # end
            #
            # it '- log_connection_id - Ok' do
            #   # puts "In check results: log_connection_id \n"
            #   expect(assigns(:log_connection_id)).to eq([])
            # end
            #
            # let(:similars_got) { assigns(:similars) }
            # let(:similars_first_pair) { similars_got[0] }
            # let(:similars_second_pair) { similars_got[1] }
            # it '- similars_first_pair - Ok' do
            #   # puts "In check results: similars_got = #{similars_first_pair} \n"
            #   first_pair_profile_ids = [similars_first_pair[:first_profile_id], similars_first_pair[:second_profile_id]].sort
            #   expect(first_pair_profile_ids).to eq([70, 81])
            #   # puts "In check results: first_pair_profile_ids = #{first_pair_profile_ids} \n"
            # end

          end

          context '- After action <internal_similars_search>: check SimilarsFound' do
            # it '- in SimilarsFound stored 2 rows of good sims pairs & first row - Ok' do
            #   get :internal_similars_search
            #   sims_count =  SimilarsFound.all.count
            #   puts "Check #internal_similars_search check SimilarsFound\n"
            #   # puts "In check SimilarsFound count rows: rows sims_count = #{sims_count.inspect} \n"
            #   expect(sims_count).to eq(2) # got 2 rows of similars
            #   first_row = SimilarsFound.first
            #   first_pair_profile_ids = [first_row.first_profile_id, first_row.second_profile_id].sort
            #   expect(first_pair_profile_ids).to eq([70, 81])
            #   # puts "In check SimilarsFound rows:  first_row = #{first_row.inspect} \n"
            #   # puts "In check SimilarsFound rows:  first_row.second_profile_id = #{first_row.second_profile_id.inspect} \n"
            #   second_row = SimilarsFound.second
            #   second_pair_profile_ids = [second_row.first_profile_id, second_row.second_profile_id].sort
            #   expect(second_pair_profile_ids).to eq([79, 82])
            #   # puts "In check SimilarsFound rows:  second_row = #{second_row.inspect} \n"
            #   # puts "In check SimilarsFound rows:  second_row.second_profile_id = #{second_row.second_profile_id.inspect} \n"
            # end
          end

        end

        describe '- Added Son - ' do

        end

        describe '- Added Daughter - ' do

        end

        describe '- Added Brother - ' do

        end

        describe '- Added Sister - ' do

        end

        describe '- Added Wife - ' do

        end


      end

      describe '- Added Male new Profile ' do
        describe '- Added Father - ' do


        end

        describe '- Added Mother - ' do


        end

        describe '- Added Son - ' do


        end

        describe '- Added Daughter - ' do


        end

        describe '- Added Brother - ' do


        end

        describe '- Added Sister - ' do


        end

        describe '- Added Husband - ' do


        end

      end


    end

  end


end
