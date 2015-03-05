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
    # create parameters
    let(:current_user) { create(:user) }   # User = 1. Tree = 1. profile_id = 63
    let(:currentuser_id) {current_user.id}


    # create model data
    before {
      # allow(controller).to receive(:logged_in?)
      # allow(controller).to receive(:current_user).and_return current_user

      # puts "1 before All: currentuser_id = #{currentuser_id} \n" # currentuser_id = 1
      # puts "before All: current_user.profile_id = #{current_user.profile_id} \n"

      FactoryGirl.create(:user, :user_2)  # User = 2. Tree = 2. profile_id = 66

      # puts "before All: User.last.id = #{User.last.id} \n" # id = 2
      # puts "before All: User.find(2).profile_id = #{User.find(2).profile_id} \n" # id = 2

      FactoryGirl.create(:connected_user, :correct)      # 1  2
      FactoryGirl.create(:connected_user, :correct_3_4)  # 3  4
      # puts "before All: ConnectedUser.count = #{ConnectedUser.all.count} \n" # 2 rows

      # Tree
      FactoryGirl.create(:tree, :tree1_with_sims_1)
      FactoryGirl.create(:tree, :tree1_with_sims_2)
      FactoryGirl.create(:tree, :tree1_with_sims_3)
      FactoryGirl.create(:tree, :tree1_with_sims_4)
      FactoryGirl.create(:tree, :tree1_with_sims_5)
      FactoryGirl.create(:tree, :tree1_with_sims_6)
      FactoryGirl.create(:tree, :tree1_with_sims_7)
      FactoryGirl.create(:tree, :tree1_with_sims_8)
      FactoryGirl.create(:tree, :tree1_with_sims_9)
      FactoryGirl.create(:tree, :tree1_with_sims_10)
      FactoryGirl.create(:tree, :tree1_with_sims_11)
      FactoryGirl.create(:tree, :tree1_with_sims_12)
      FactoryGirl.create(:tree, :tree1_with_sims_13)
      FactoryGirl.create(:tree, :tree1_with_sims_14)
      FactoryGirl.create(:tree, :tree1_with_sims_15)
      FactoryGirl.create(:tree, :tree1_with_sims_16)
      FactoryGirl.create(:tree, :tree1_with_sims_17)
      FactoryGirl.create(:tree, :tree1_with_sims_18)
      FactoryGirl.create(:tree, :tree1_with_sims_19)
      FactoryGirl.create(:tree, :tree1_with_sims_20)
      # puts "before All: Tree.find(20).profile_id = #{Tree.find(20).profile_id.inspect} \n"  # id = 64
      # puts "before All: Tree.last.is_profile_id = #{Tree.last.is_profile_id} \n"  # is_profile_id = 84
      # puts "before All: Tree.count = #{Tree.all.count} \n" # 20

      # Profile
      FactoryGirl.create(:profile, :profile_63)
      FactoryGirl.create(:profile, :profile_64)
      FactoryGirl.create(:profile, :profile_65)
      FactoryGirl.create(:profile, :profile_66)
      FactoryGirl.create(:profile, :profile_67)
      FactoryGirl.create(:profile, :profile_68)
      FactoryGirl.create(:profile, :profile_69)
      FactoryGirl.create(:profile, :profile_70)
      FactoryGirl.create(:profile, :profile_78)
      FactoryGirl.create(:profile, :profile_79)
      FactoryGirl.create(:profile, :profile_80)
      FactoryGirl.create(:profile, :profile_81)
      FactoryGirl.create(:profile, :profile_82)
      FactoryGirl.create(:profile, :profile_83)
      FactoryGirl.create(:profile, :profile_84)
      # puts "before All: Profile.last.id = #{Profile.last.id} \n"  # id = 64
      # puts "before All: Profile.last.name_id = #{Profile.last.name_id} \n"  # name_id = 90
      # puts "before All: Profile.count = #{Profile.all.count} \n" # 2

      #Profile_Key
      FactoryGirl.create(:profile_key, :profile_key_w_sims_1)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_2)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_3)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_4)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_5)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_6)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_7)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_8)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_9)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_10)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_11)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_12)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_13)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_14)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_15)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_16)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_17)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_18)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_19)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_20)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_21)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_22)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_23)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_24)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_25)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_26)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_27)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_28)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_29)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_30)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_31)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_32)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_33)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_34)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_35)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_36)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_37)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_38)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_39)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_40)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_41)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_42)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_43)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_44)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_45)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_46)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_47)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_48)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_49)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_50)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_51)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_52)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_53)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_54)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_55)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_56)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_57)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_58)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_59)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_60)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_61)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_62)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_63)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_64)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_65)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_66)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_67)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_68)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_69)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_70)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_71)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_72)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_73)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_74)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_75)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_76)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_77)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_78)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_79)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_80)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_81)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_82)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_83)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_84)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_85)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_86)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_87)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_88)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_89)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_90)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_91)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_92)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_93)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_94)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_95)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_96)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_97)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_98)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_99)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_100)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_101)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_102)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_103)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_104)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_105)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_106)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_107)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_108)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_109)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_110)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_111)
      FactoryGirl.create(:profile_key, :profile_key_w_sims_112)
      # puts "before All: ProfileKey.last.user_id = #{ProfileKey.last.user_id} \n"  # user_id = 1
      # puts "before All: ProfileKey.last.name_id = #{ProfileKey.last.is_name_id} \n"  # name_id = 187
      # puts "before All: ProfileKey.count = #{ProfileKey.all.count} \n" # 112

      #Name
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
       # puts "before All: Name.first.name = #{Name.first.name} \n"  # Алексей

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


    context '- before actions - check connected_users' do
      let(:connected_users) { current_user.get_connected_users }
      it "- Return proper connected_users Array result for current_user_id = 1" do
        puts "Check ProfileKey Model methods \n"
        puts "Before All - data created \n"  #
        # puts "1 1 In check connected_users :  connected_users = #{connected_users} \n"
        expect(connected_users).to be_a_kind_of(Array)
      end
      it "- Return proper connected_users Array result for current_user_id = 1" do
        # puts "1 2 In check connected_users :  connected_users = #{connected_users} \n"
        expect(connected_users).to eq([1,2])
      end
    end

    # from home_controller.rb#index
    describe 'GET #add_new_profile *' do

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
        #
        # it '- similars_second_pair - Ok' do
        #   # puts "In check results: similars_got = #{similars_second_pair} \n"
        #   second_pair_profile_ids = [similars_second_pair[:first_profile_id], similars_second_pair[:second_profile_id]].sort
        #   expect(second_pair_profile_ids).to eq([79, 82])
        #   # puts "In check results: second_pair_profile_ids = #{second_pair_profile_ids} \n"
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

  end


end
