require 'rails_helper'

RSpec.describe ProfileKey, :type => :model do

  describe '- validation' do
    describe '- on create' do

      context '- valid profile_key' do
        let(:profilekey_row) {FactoryGirl.build(:profile_key)}  #
        it '- saves a valid profilekey_row' do
          puts "Model ProfileKey validation "
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

    # create model data
    before {
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
      # puts "before All: Name.first.name = #{Name.first.name} \n"  # Алексей

      #Relation -  # before
      FactoryGirl.create(:relation)
      FactoryGirl.create(:relation, :relation_2)
      FactoryGirl.create(:relation, :relation_3)
      FactoryGirl.create(:relation, :relation_4)
      FactoryGirl.create(:relation, :relation_5)
      FactoryGirl.create(:relation, :relation_6)
      FactoryGirl.create(:relation, :relation_7)
      FactoryGirl.create(:relation, :relation_8)
      FactoryGirl.create(:relation, :relation_9)
      FactoryGirl.create(:relation, :relation_10)
      FactoryGirl.create(:relation, :relation_11)
      FactoryGirl.create(:relation, :relation_12)
      FactoryGirl.create(:relation, :relation_13)
      FactoryGirl.create(:relation, :relation_14)
      FactoryGirl.create(:relation, :relation_15)
      FactoryGirl.create(:relation, :relation_16)
      FactoryGirl.create(:relation, :relation_17)
      FactoryGirl.create(:relation, :relation_18)
      FactoryGirl.create(:relation, :relation_19)
      FactoryGirl.create(:relation, :relation_20)
      FactoryGirl.create(:relation, :relation_21)
      FactoryGirl.create(:relation, :relation_22)
      FactoryGirl.create(:relation, :relation_23)
      FactoryGirl.create(:relation, :relation_24)
      FactoryGirl.create(:relation, :relation_25)
      FactoryGirl.create(:relation, :relation_26)
      FactoryGirl.create(:relation, :relation_27)
      FactoryGirl.create(:relation, :relation_28)
      FactoryGirl.create(:relation, :relation_29)
      FactoryGirl.create(:relation, :relation_30)
      FactoryGirl.create(:relation, :relation_31)
      FactoryGirl.create(:relation, :relation_32)
      FactoryGirl.create(:relation, :relation_33)
      FactoryGirl.create(:relation, :relation_34)
      FactoryGirl.create(:relation, :relation_35)
      FactoryGirl.create(:relation, :relation_36)
      FactoryGirl.create(:relation, :relation_37)
      FactoryGirl.create(:relation, :relation_38)
      FactoryGirl.create(:relation, :relation_39)
      FactoryGirl.create(:relation, :relation_40)
      FactoryGirl.create(:relation, :relation_41)
      FactoryGirl.create(:relation, :relation_42)
      FactoryGirl.create(:relation, :relation_43)
      FactoryGirl.create(:relation, :relation_44)
      FactoryGirl.create(:relation, :relation_45)
      FactoryGirl.create(:relation, :relation_46)
      FactoryGirl.create(:relation, :relation_47)
      FactoryGirl.create(:relation, :relation_48)
      FactoryGirl.create(:relation, :relation_49)
      FactoryGirl.create(:relation, :relation_50)
      FactoryGirl.create(:relation, :relation_51)
      FactoryGirl.create(:relation, :relation_52)
      FactoryGirl.create(:relation, :relation_53)
      FactoryGirl.create(:relation, :relation_54)
      FactoryGirl.create(:relation, :relation_55)
      FactoryGirl.create(:relation, :relation_56)

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
      # puts "before All: User.first = #{User.first.id} \n" # id = 10
      # puts "before All: User.last.id = #{User.last.id} \n" # id = 10

      # ConnectedUser
      FactoryGirl.create(:connected_user, :correct)      # 1  2
      FactoryGirl.create(:connected_user, :correct_3_4)  # 3  4
      # puts "before All: ConnectedUser.count = #{ConnectedUser.all.count} \n" # 2 rows

      # Profile
      FactoryGirl.create(:add_profile, :add_profile_85)   # 85
      # FactoryGirl.create(:profile, :add_profile_86)   # 86
      # FactoryGirl.create(:profile, :add_profile_87)   # 87
      FactoryGirl.create(:add_profile, :add_profile_88) # before
      FactoryGirl.create(:add_profile, :add_profile_89) # before
      FactoryGirl.create(:add_profile, :add_profile_90) # before
      FactoryGirl.create(:add_profile, :add_profile_91) # before
      # FactoryGirl.create(:profile, :add_profile_92)   # 92
      # FactoryGirl.create(:profile, :add_profile_93) # user_10 # before
      # FactoryGirl.create(:profile, :add_profile_94)
      # FactoryGirl.create(:profile, :add_profile_95)
      # FactoryGirl.create(:profile, :add_profile_96) # before
      # FactoryGirl.create(:profile, :add_profile_97) # before
      # FactoryGirl.create(:profile, :add_profile_98) # before
      # FactoryGirl.create(:profile, :add_profile_99) # before
      # FactoryGirl.create(:profile, :add_profile_100)

      # puts "before All: base_profile_85.id = #{base_profile_85.id} \n"  # id =
      # puts "before All: base_profile_85.user_id = #{base_profile_85.user_id} \n"  # id =
      # puts "before All: base_profile_85.name_id = #{base_profile_85.name_id} \n"  # id =
      # puts "before All: base_profile_85.sex_id = #{base_profile_85.sex_id} \n"  # id =
      # puts "before All: base_profile_85.tree_id = #{base_profile_85.tree_id} \n"  # id =
      # puts "before All: Profile.find(89).sex_id = #{Profile.find(89).sex_id} \n"  # id =
      # puts "before All: Profile.first.id = #{Profile.first.id} \n"  # id =

      # puts "before All: Profile.last.id = #{Profile.last.id} \n"  # id =
      # puts "before All: Profile.last.name_id = #{Profile.last.name_id} \n"  # name_id = 90
      # puts "before All: Profile.last.sex_id = #{Profile.last.sex_id} \n"  # name_id = 90
      # puts "before All: Profile.count = #{Profile.all.count} \n" # 2

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
      # puts "before All: Tree.last.is_profile_id = #{Tree.last.is_profile_id} \n"  # is_profile_id = 84
      # puts "before All: Tree.last.is_sex_id = #{Tree.last.is_sex_id} \n"  # is_sex_id = 84
      # puts "before All: Tree.count = #{Tree.all.count} \n" # 20


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
      # puts "before All: ProfileKey.last.user_id = #{ProfileKey.last.user_id} \n"  # user_id = 1
      # puts "before All: ProfileKey.last.name_id = #{ProfileKey.last.is_name_id} \n"  # name_id = 187
      # puts "before All: ProfileKey.count = #{ProfileKey.all.count} \n" # 112

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
        # puts "Let created: currentuser_id = #{currentuser_id}, current_user_9.profile_id = #{current_user_9.profile_id} \n"
        # currentuser_id = 9  profile_id = 85
        # puts "Let created: connected_users = #{connected_users} \n"   # [9]
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
            FactoryGirl.create(:add_profile, :add_profile_87)   # 87
            FactoryGirl.create(:add_profile, :add_profile_92)   # 92

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
            Relation.delete_all
            Relation.reset_pk_sequence
          }

          context '- before action <add_new_profile> - check created data' do
            puts "Before action Add Father- data created \n"  #
            it "- Return proper connected_users Array result for current_user_id = 1" do
              expect(connected_users).to eq([9])
            end
          end

          let(:base_profile) {Profile.find(85)}
          let(:base_sex_id) {base_profile.sex_id}
          let(:new_profile_86) { create(:add_profile, :add_profile_86) } # User = nil. Tree = 9. profile_id = 86
                                                                         # name_id   370   sex_id    1
          let(:new_relation_id) {1} # Father
          let(:exclusions_hash) {{}}
          let(:tree_ids) {connected_users}

          context '- before action <add_new_profile> - check input params values ' do
            it "- check: base_profile" do
              puts "Check Add Father \n"  # 1
              expect(base_profile.id).to eq(85)
            end
            it "- check: base_sex_id" do
              # puts "check base_sex_id: = #{base_sex_id} \n"  # 1
              expect(base_sex_id).to eq(1)
            end
            it "- check: base_profile" do
              # puts "check base_profile.id: = #{base_profile.id} \n"  # ActiveRecord
              expect(base_profile).to be_valid
            end
            it "- check: new_profile_86" do
               # puts "check new_profile_86.id: = #{new_profile_86.id} \n"  # ActiveRecord
              expect(new_profile_86).to be_valid
            end
            it "- check: new_relation_id" do
              # puts "check new_relation_id: = #{new_relation_id} \n"  # 1
              expect(new_relation_id).to eq(1)
            end
            it "- check: exclusions_hash" do
              # puts "check exclusions_hash: = #{exclusions_hash} \n"  # 1
              expect(exclusions_hash).to eq({})
            end
            it "- check: tree_ids" do
              # puts "check tree_ids: = #{tree_ids} \n"  # 1
              expect(tree_ids).to eq([9])
            end
            it '- Tree check have rows count before - Ok' do
              trees_count =  Tree.all.count
              # puts "before action: trees_count = #{trees_count.inspect} \n"
              expect(trees_count).to eq(6) # got 6 rows of Tree
            end
            it '- Profile check have rows count & ids before - Ok' do
              profiles_count =  Profile.all.count
              puts "before action: profiles_count = #{profiles_count.inspect} \n"
              expect(profiles_count).to eq(7) # count of Profile
              profiles_ids =  Profile.all.pluck(:id).sort
              puts "before action: profiles_ids = #{profiles_ids.inspect} \n"
              expect(profiles_ids).to eq([85, 87, 88, 89, 90, 91, 92])
              # ids of Profiles
              # puts "before All: base_profile.id = #{base_profile.id} \n"  # id = 85
              # puts "before All: base_profile.user_id = #{base_profile.user_id} \n"  # id = 9
            end
            it '- ProfileKey check have rows count & ids before - Ok' do
              profile_keys_count =  ProfileKey.all.count
              puts "before action: profile_keys_count = #{profile_keys_count.inspect} \n"
              expect(profile_keys_count).to eq(38) # count of Profile
              profile_keys_ids =  ProfileKey.all.pluck(:id).sort
              # puts "before action: profile_keys_ids = #{profile_keys_ids.inspect} \n"
              expect(profile_keys_ids).to eq([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
                                             20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36,
                                             37, 38]) # ids of ProfileKeys
              # puts "before All: base_profile.id = #{base_profile.id} \n"  # id = 85
              # puts "before All: base_profile.user_id = #{base_profile.user_id} \n"  # id = 9
            end

          end

          context '- After ADD Father - action <add_new_profile>:' do
            before { ProfileKey.add_new_profile( base_sex_id, base_profile, new_profile_86, new_relation_id,
                                exclusions_hash: exclusions_hash_empty, tree_ids: tree_ids_conn ) }

            let(:base_profile) {Profile.find(85)}
            let(:base_sex_id) {base_profile.sex_id}
            let(:new_profile_86) { create(:add_profile, :add_profile_86) }  # User = nil. Tree = 9. profile_id = 86
            # name_id   370   sex_id    1
            let(:new_relation_id) {1} # Father
            let(:exclusions_hash_empty) {{}}
            let(:tree_ids_conn) {connected_users}

            it '- check new Tree row - Ok' do
              puts "After ADD Father Check Tree \n"
              # puts "In Check Tree: connected_users = #{connected_users}\n"
              # puts "In Check Tree: tree_ids = #{tree_ids}\n"
              # [85, 1, 370, nil, 1, 86, 28, nil]
              new_tree_row = Tree.last
              tree_row_id = new_tree_row.id
              # puts "In check results: tree_row_id = #{tree_row_id} \n"
              expect(tree_row_id).to eq(7) #

              new_user_id = new_tree_row.user_id
              # puts "In check results: new_user_id = #{new_user_id} \n"
              expect(new_user_id).to eq(9) #

              new_profile_id = new_tree_row.profile_id
              # puts "In check results: new_profile_id = #{new_profile_id} \n"
              expect(new_profile_id).to eq(85) #

              new_name_id = new_tree_row.name_id
              # puts "In check results: new_name_id = #{new_name_id} \n"
              expect(new_name_id).to eq(370) #

              new_relation_id = new_tree_row.relation_id
              # puts "In check results: new_relation_id = #{new_relation_id} \n"
              expect(new_relation_id).to eq(1) #

              new_is_profile_id = new_tree_row.is_profile_id
              # puts "In check results: new_is_profile_id = #{new_is_profile_id} \n"
              expect(new_is_profile_id).to eq(86) #

              new_is_name_id = new_tree_row.is_name_id
              # puts "In check results: new_is_name_id = #{new_is_name_id} \n"
              expect(new_is_name_id).to eq(28) #

              new_is_sex_id = new_tree_row.is_sex_id
              # puts "In check results: new_is_sex_id = #{new_is_sex_id} \n"
              expect(new_is_sex_id).to eq(1) #
            end

            it '- check new ProfileKey rows - Ok' do
              profilekeys_count =  ProfileKey.all.count
              puts "After ADD Father Check ProfileKey \n"
              puts "In check ProfileKey: profilekeys_count = #{profilekeys_count.inspect} \n"
              expect(profilekeys_count).to eq(52) # got 52 rows of ProfileKey
            end

            it '- check all relations generated in ProfileKey rows - Ok' do
              all_relations =  ProfileKey.all.pluck(:relation_id).sort
              puts "After ADD Father Check ProfileKey \n"
              # puts "In check ProfileKey: all_relations = #{all_relations.inspect} \n"
              expect(all_relations).to eq([1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5, 6,
                                           6, 6, 7, 7, 8, 8, 13, 14, 17, 17, 91, 91, 101, 101, 111, 111, 121, 121, 191,
                                           191, 201, 201, 211, 211, 221, 221]) # got 52 relations of ProfileKey
              puts "In check ProfileKey: all_relations = #{all_relations.size} \n"# unless all_relations_w_fa.blank?
              expect(all_relations.size).to eq(52)
            end

            it '- check new Profile rows - Ok' do
              profiles_count =  Profile.all.count
              puts "After ADD Father Check Profile \n"
              puts "In check Profile: profiles_count = #{profiles_count.inspect} \n"
              expect(profiles_count).to eq(8) # got 8 rows of Profile
            end
          end
        end

        describe '- Added Mother - ' do
          before {
            # Tree
            FactoryGirl.create(:tree, :add_tree9_1)   # 86
            # FactoryGirl.create(:tree, :add_tree9_2)   # 87
            FactoryGirl.create(:tree, :add_tree9_7)   # 92

            # Profile
            FactoryGirl.create(:add_profile, :add_profile_86)   # 86
            # FactoryGirl.create(:add_profile, :add_profile_87)   # 87
            FactoryGirl.create(:add_profile, :add_profile_92)   # 92

            #Profile_Key
            # Before Add new Profile  -  tree #9 Petr
            FactoryGirl.create(:profile_key, :profile_key9_add_1)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_2)   # 86
            # FactoryGirl.create(:profile_key, :profile_key9_add_3)   # 87
            # FactoryGirl.create(:profile_key, :profile_key9_add_4)   # 87
            # FactoryGirl.create(:profile_key, :profile_key9_add_5)   # 86, 87
            # FactoryGirl.create(:profile_key, :profile_key9_add_6)   # 86, 87
            FactoryGirl.create(:profile_key, :profile_key9_add_9)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_10)   # 86
            # FactoryGirl.create(:profile_key, :profile_key9_add_11)   # 87
            # FactoryGirl.create(:profile_key, :profile_key9_add_12)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_15)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_16)   # 86
            # FactoryGirl.create(:profile_key, :profile_key9_add_17)   # 87
            # FactoryGirl.create(:profile_key, :profile_key9_add_18)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_23)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_24)   # 86
            # FactoryGirl.create(:profile_key, :profile_key9_add_25)   # 87
            # FactoryGirl.create(:profile_key, :profile_key9_add_26)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_35)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_36)   # 86
            # FactoryGirl.create(:profile_key, :profile_key9_add_37)   # 87
            # FactoryGirl.create(:profile_key, :profile_key9_add_38)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_43)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_44)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_45)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_46)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_47)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_48)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_49)   # 92 86
            FactoryGirl.create(:profile_key, :profile_key9_add_50)   # 92 86
            # FactoryGirl.create(:profile_key, :profile_key9_add_51)   # 92 87
            # FactoryGirl.create(:profile_key, :profile_key9_add_52)   # 92 87

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
            Relation.delete_all
            Relation.reset_pk_sequence
          }

          context '- before action <add_new_profile> - check created data' do
            puts "Before action Add Mother- data created \n"  #
            it "- Return proper connected_users Array result for current_user_id = 1" do
              expect(connected_users).to eq([9])
            end
          end

          let(:base_profile) {Profile.find(85)}
          let(:base_sex_id) {base_profile.sex_id}
          let(:new_profile_87) { create(:add_profile, :add_profile_87) } # User = nil. Tree = 9. profile_id = 87
          # name_id   370   sex_id    1
          let(:new_relation_id) {2} # Mother
          let(:exclusions_hash) {{}}
          let(:tree_ids) {connected_users}

          context '- before action <add_new_profile> - check input params values ' do
            it "- check: base_profile" do
              puts "Check Add Mother \n"  # 2
              expect(base_profile.id).to eq(85)
            end
            it "- check: base_sex_id" do
              # puts "check base_sex_id: = #{base_sex_id} \n"  # 1
              expect(base_sex_id).to eq(1)
            end
            it "- check: base_profile" do
              # puts "check base_profile.id: = #{base_profile.id} \n"  # ActiveRecord
              expect(base_profile).to be_valid
            end
            it "- check: new_profile_87" do
              # puts "check new_profile_87.id: = #{new_profile_87.id} \n"  # ActiveRecord
              expect(new_profile_87).to be_valid
            end
            it "- check: new_relation_id" do
              # puts "check new_relation_id: = #{new_relation_id} \n"  # 1
              expect(new_relation_id).to eq(2)
            end
            it "- check: exclusions_hash" do
              # puts "check exclusions_hash: = #{exclusions_hash} \n"  # 1
              expect(exclusions_hash).to eq({})
            end
            it "- check: tree_ids" do
              # puts "check tree_ids: = #{tree_ids} \n"  # 1
              expect(tree_ids).to eq([9])
            end
            it '- Tree check have rows count before - Ok' do
              trees_count =  Tree.all.count
              # puts "before action: trees_count = #{trees_count.inspect} \n"
              expect(trees_count).to eq(6) # got 6 rows of Tree
            end
            it '- Profile check have rows count & ids before - Ok' do
              profiles_count =  Profile.all.count
              puts "before action: profiles_count = #{profiles_count.inspect} \n"
              expect(profiles_count).to eq(7) # count of Profile
              profiles_ids =  Profile.all.pluck(:id).sort
              puts "before action: profiles_ids = #{profiles_ids.inspect} \n"
              expect(profiles_ids).to eq([85, 86, 88, 89, 90, 91, 92]) # ids of Profiles
              # puts "before All: base_profile.id = #{base_profile.id} \n"  # id = 85
              # puts "before All: base_profile.user_id = #{base_profile.user_id} \n"  # id = 9
            end
            it '- ProfileKey check have rows count & ids before - Ok' do
              profile_keys_count =  ProfileKey.all.count
              puts "before action: profile_keys_count = #{profile_keys_count.inspect} \n"
              expect(profile_keys_count).to eq(38) # count of Profile
              profile_keys_ids =  ProfileKey.all.pluck(:id).sort
              # puts "before action: profile_keys_ids = #{profile_keys_ids.inspect} \n"
              expect(profile_keys_ids).to eq([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
                                              20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36,
                                              37, 38]) # ids of ProfileKeys
              # puts "before All: base_profile.id = #{base_profile.id} \n"  # id = 85
              # puts "before All: base_profile.user_id = #{base_profile.user_id} \n"  # id = 9
            end
          end

          context '- After Added Mother - action <add_new_profile>:' do
            before { ProfileKey.add_new_profile( base_sex_id, base_profile, new_profile_87, new_relation_id,
                                                 exclusions_hash: exclusions_hash_empty, tree_ids: tree_ids_conn ) }

            let(:base_profile) {Profile.find(85)}
            let(:base_sex_id) {base_profile.sex_id}
            let(:new_profile_87) { create(:add_profile, :add_profile_87) }  # User = nil. Tree = 9. profile_id = 87
            # name_id   48   sex_id    0
            let(:new_relation_id) {2} # Mother
            let(:exclusions_hash_empty) {{}}
            let(:tree_ids_conn) {connected_users}

            it '- check new Tree row - Ok' do
              puts "After ADD Mother Check Tree \n"
              # puts "In Check Tree: connected_users = #{connected_users}\n"
              # puts "In Check Tree: tree_ids = #{tree_ids}\n"
              new_tree_row = Tree.last
              tree_row_id = new_tree_row.id
              # puts "In check results: tree_row_id = #{tree_row_id} \n"
              expect(tree_row_id).to eq(7) #

              new_user_id = new_tree_row.user_id
              # puts "In check results: new_user_id = #{new_user_id} \n"
              expect(new_user_id).to eq(9) #

              new_profile_id = new_tree_row.profile_id
              # puts "In check results: new_profile_id = #{new_profile_id} \n"
              expect(new_profile_id).to eq(85) #

              new_name_id = new_tree_row.name_id
              # puts "In check results: new_name_id = #{new_name_id} \n"
              expect(new_name_id).to eq(370) #

              new_relation_id = new_tree_row.relation_id
              # puts "In check results: new_relation_id = #{new_relation_id} \n"
              expect(new_relation_id).to eq(2) #

              new_is_profile_id = new_tree_row.is_profile_id
              # puts "In check results: new_is_profile_id = #{new_is_profile_id} \n"
              expect(new_is_profile_id).to eq(87) #

              new_is_name_id = new_tree_row.is_name_id
              # puts "In check results: new_is_name_id = #{new_is_name_id} \n"
              expect(new_is_name_id).to eq(48) #

              new_is_sex_id = new_tree_row.is_sex_id
              # puts "In check results: new_is_sex_id = #{new_is_sex_id} \n"
              expect(new_is_sex_id).to eq(0) #
            end

            it '- check new ProfileKey rows - Ok' do
              profilekeys_count =  ProfileKey.all.count
              puts "After ADD Mother Check ProfileKey \n"
              puts "In check ProfileKey: profilekeys_count = #{profilekeys_count.inspect} \n"
              expect(profilekeys_count).to eq(52) # got 52 rows of ProfileKey
            end

            it '- check all users generated in ProfileKey rows - Ok' do
              all_users =  ProfileKey.all.pluck(:user_id).uniq
              puts "After ADD Mother Check ProfileKey \n"
              expect(all_users).to eq([9]) # got the same user_id for all rows of ProfileKey
              puts "In check ProfileKey: the same all_users = #{all_users} \n"
              expect(all_users.size).to eq(1)
            end

            it '- check all relations generated in ProfileKey rows - Ok' do
              all_relations =  ProfileKey.all.pluck(:relation_id).sort
              puts "After ADD Mother Check ProfileKey \n"
              # puts "In check ProfileKey: all_relations = #{all_relations.inspect} \n"
              expect(all_relations).to eq([1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5, 6,
                                           6, 6, 7, 7, 8, 8, 13, 14, 17, 17, 91, 91, 101, 101, 111, 111, 121, 121, 191,
                                           191, 201, 201, 211, 211, 221, 221]) # got 52 relations of ProfileKey
              puts "In check ProfileKey: all_relations = #{all_relations.size} \n"
              expect(all_relations.size).to eq(52)
            end

            it '- check new Profile rows - Ok' do
              profiles_count =  Profile.all.count
              puts "After ADD Mother Check Profile \n"
              puts "In check Profile: profiles_count = #{profiles_count.inspect} \n"
              expect(profiles_count).to eq(8) # got 8 rows of Profile
            end
          end
        end

        describe '- Added Son - ' do
          before {
            # Tree
            FactoryGirl.create(:tree, :add_tree9_1)   # 86
            FactoryGirl.create(:tree, :add_tree9_2)   # 87
            FactoryGirl.create(:tree, :add_tree9_7)   # 92

            # Profile
            FactoryGirl.create(:add_profile, :add_profile_86)   # 86
            FactoryGirl.create(:add_profile, :add_profile_87)   # 87
            FactoryGirl.create(:add_profile, :add_profile_92)   # 92

            #Profile_Key
            # Before Add new Profile  -  tree #9 Petr
            FactoryGirl.create(:profile_key, :profile_key9_add_1)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_2)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_3)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_4)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_5)   # 86, 87
            FactoryGirl.create(:profile_key, :profile_key9_add_6)   # 86, 87
            FactoryGirl.create(:profile_key, :profile_key9_add_9)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_10)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_11)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_12)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_15)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_16)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_17)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_18)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_23)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_24)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_25)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_26)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_35)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_36)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_37)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_38)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_43)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_44)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_45)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_46)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_47)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_48)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_49)   # 92 86
            FactoryGirl.create(:profile_key, :profile_key9_add_50)   # 92 86
            FactoryGirl.create(:profile_key, :profile_key9_add_51)   # 92 87
            FactoryGirl.create(:profile_key, :profile_key9_add_52)   # 92 87

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
            Name.delete_all
            Name.reset_pk_sequence
            Relation.delete_all
            Relation.reset_pk_sequence
          }

          context '- before action <add_new_profile> - check created data' do
            puts "Before action Add Son- data created \n"  #
            it "- Return proper connected_users Array result for current_user_id = 1" do
              expect(connected_users).to eq([9])
            end
          end

          let(:base_profile) {Profile.find(85)}
          let(:base_sex_id) {base_profile.sex_id}
          let(:new_profile_101) { create(:add_profile, :add_profile_101) } # User = nil. Tree = 9. profile_id = 101
          # name_id   419   sex_id    1
          let(:new_relation_id) {3} # Son Семен
          let(:exclusions_hash) {{}}
          let(:tree_ids) {connected_users}

          context '- before action <add_new_profile> - check input params values ' do
            it "- check: base_profile" do
              puts "Check Add Son \n"  # 3
              expect(base_profile.id).to eq(85)
            end
            it "- check: base_sex_id" do
              # puts "check base_sex_id: = #{base_sex_id} \n"  # 1
              expect(base_sex_id).to eq(1)
            end
            it "- check: base_profile" do
              # puts "check base_profile.id: = #{base_profile.id} \n"  # ActiveRecord
              expect(base_profile).to be_valid
            end
            it "- check: new_profile_101" do
              # puts "check new_profile_101.id: = #{new_profile_101.id} \n"  # ActiveRecord
              expect(new_profile_101).to be_valid
            end
            it "- check: new_relation_id" do
              # puts "check new_relation_id: = #{new_relation_id} \n"  # 1
              expect(new_relation_id).to eq(3)
            end
            it "- check: exclusions_hash" do
              # puts "check exclusions_hash: = #{exclusions_hash} \n"  # 1
              expect(exclusions_hash).to eq({})
            end
            it "- check: tree_ids" do
              # puts "check tree_ids: = #{tree_ids} \n"  # 1
              expect(tree_ids).to eq([9])
            end
            it '- Tree check have rows count before - Ok' do
              trees_count =  Tree.all.count
              # puts "before action: trees_count = #{trees_count.inspect} \n"
              expect(trees_count).to eq(7) # got 7 rows of Tree - before
            end
            it '- Profile check have rows count & ids before - Ok' do
              profiles_count =  Profile.all.count
              puts "before action: profiles_count = #{profiles_count.inspect} \n"
              expect(profiles_count).to eq(8) # count of Profile
              profiles_ids =  Profile.all.pluck(:id).sort
              puts "before action: profiles_ids = #{profiles_ids.inspect} \n"
              expect(profiles_ids).to eq([85, 86, 87, 88, 89, 90, 91, 92]) # ids of Profiles
            end
            it '- ProfileKey check have rows count & ids before - Ok' do
              profile_keys_count =  ProfileKey.all.count
              puts "before action: profile_keys_count = #{profile_keys_count.inspect} \n"
              expect(profile_keys_count).to eq(52) # count of ProfileKey
              profile_keys_ids =  ProfileKey.all.pluck(:id).sort
              # puts "before action: profile_keys_ids = #{profile_keys_ids.inspect} \n"
              expect(profile_keys_ids).to eq([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
                                              21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38,
                                              39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52]) # ids of ProfileKeys
            end
          end

          context '- After Added Son - action <add_new_profile>:' do
            before { ProfileKey.add_new_profile( base_sex_id, base_profile, new_profile_101, new_relation_id,
                                                 exclusions_hash: exclusions_hash_empty, tree_ids: tree_ids_conn ) }
            let(:base_profile) {Profile.find(85)}
            let(:base_sex_id) {base_profile.sex_id}
            # ADD Son
            let(:new_profile_101) { create(:add_profile, :add_profile_101) }  # User = nil. Tree = 9. profile_id = 87
            # name_id   419   sex_id    0
            let(:new_relation_id) {3} # Son
            let(:exclusions_hash_empty) {{}}
            let(:tree_ids_conn) {connected_users}

            it '- check new Tree row - Ok' do
              puts "After ADD Son Check Tree \n"
              # puts "In Check Tree: connected_users = #{connected_users}\n"
              # puts "In Check Tree: tree_ids = #{tree_ids}\n"
              new_tree_row = Tree.last
              tree_row_id = new_tree_row.id
              # puts "In check results: tree_row_id = #{tree_row_id} \n"
              expect(tree_row_id).to eq(8) #

              new_user_id = new_tree_row.user_id
              # puts "In check results: new_user_id = #{new_user_id} \n"
              expect(new_user_id).to eq(9) #

              new_profile_id = new_tree_row.profile_id
              # puts "In check results: new_profile_id = #{new_profile_id} \n"
              expect(new_profile_id).to eq(85) #

              new_name_id = new_tree_row.name_id
              # puts "In check results: new_name_id = #{new_name_id} \n"
              expect(new_name_id).to eq(370) #

              new_relation_id = new_tree_row.relation_id
              # puts "In check results: new_relation_id = #{new_relation_id} \n"
              expect(new_relation_id).to eq(3) #

              new_is_profile_id = new_tree_row.is_profile_id
              # puts "In check results: new_is_profile_id = #{new_is_profile_id} \n"
              expect(new_is_profile_id).to eq(101) #

              new_is_name_id = new_tree_row.is_name_id
              # puts "In check results: new_is_name_id = #{new_is_name_id} \n"
              expect(new_is_name_id).to eq(419) #

              new_is_sex_id = new_tree_row.is_sex_id
              # puts "In check results: new_is_sex_id = #{new_is_sex_id} \n"
              expect(new_is_sex_id).to eq(1) #
            end

            it '- check new ProfileKey rows - Ok' do
              profilekeys_count =  ProfileKey.all.count
              puts "After ADD Son Check ProfileKey \n"
              puts "In check ProfileKey: profilekeys_count = #{profilekeys_count.inspect} \n"
              expect(profilekeys_count).to eq(68) # got 68 rows of ProfileKey
            end

            it '- check all profile_ids generated in ProfileKey rows - Ok' do
              all_profile_ids =  ProfileKey.all.pluck(:profile_id).sort
              puts "After ADD Son Check ProfileKey \n"
              # expect(all_profile_ids).to eq([85, 88, 85, 89, 88, 89, 85, 90, 88, 90, 89, 90, 85, 91, 90, 91, 88, 91,
              #                                89, 91, 85, 86, 85, 87, 86, 87, 86, 88, 87, 88, 86, 89, 87, 89, 86, 90,
              #                                87, 90, 86, 91, 87, 91, 85, 92, 90, 92, 91, 92, 86, 92, 87, 92, 85, 101,
              #                                92, 101, 90, 101, 91, 101, 86, 101, 87, 101, 88, 101, 89, 101])
              expect(all_profile_ids).to eq([85, 85, 85, 85, 85, 85, 85, 85, 86, 86, 86, 86, 86, 86, 86, 86, 87, 87, 87,
                                             87, 87, 87, 87, 87, 88, 88, 88, 88, 88, 88, 88, 89, 89, 89, 89, 89, 89, 89,
                                             90, 90, 90, 90, 90, 90, 90, 90, 91, 91, 91, 91, 91, 91, 91, 91, 92, 92, 92,
                                             92, 92, 92, 101, 101, 101, 101, 101, 101, 101, 101])
                                             # got on user_id for all rows of ProfileKey
              puts "In check ProfileKey: all_profile_ids = #{all_profile_ids.size} \n"
              expect(all_profile_ids.size).to eq(68)
            end

            it '- check all relations generated in ProfileKey rows - Ok' do
              all_relations =  ProfileKey.all.pluck(:relation_id).sort
              # puts "After ADD Son Check ProfileKey \n"
              # puts "In check ProfileKey: all_relations = #{all_relations.inspect} \n"
              expect(all_relations).to eq([1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5,
                                           5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 8, 8, 13, 14, 17, 17, 91, 91, 91, 101,
                                           101, 101, 111, 111, 111, 111, 121, 121, 191, 191, 191, 201, 201, 201, 211,
                                           211, 211, 211, 221, 221]) # got 52 relations of ProfileKey
              puts "In check ProfileKey: all_relations = #{all_relations.size} \n"
              expect(all_relations.size).to eq(68)
            end

            it '- check new Profile rows - Ok' do
              profiles_count =  Profile.all.count
              puts "After ADD Son Check Profile \n"
              puts "In check Profile: profiles_count = #{profiles_count.inspect} \n"
              expect(profiles_count).to eq(9) # got 9 rows of Profile
            end
          end
        end

        describe '- Added Son_to_Author - ' do
          before {
            # Tree
            FactoryGirl.create(:tree, :add_tree9_1)   # 86
            FactoryGirl.create(:tree, :add_tree9_2)   # 87
            FactoryGirl.create(:tree, :add_tree9_7)   # 92

            # Profile
            FactoryGirl.create(:add_profile, :add_profile_86)   # 86
            FactoryGirl.create(:add_profile, :add_profile_87)   # 87
            FactoryGirl.create(:add_profile, :add_profile_92)   # 92

            #Profile_Key
            # Before Add new Profile  -  tree #9 Petr
            FactoryGirl.create(:profile_key, :profile_key9_add_1)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_2)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_3)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_4)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_5)   # 86, 87
            FactoryGirl.create(:profile_key, :profile_key9_add_6)   # 86, 87
            FactoryGirl.create(:profile_key, :profile_key9_add_9)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_10)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_11)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_12)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_15)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_16)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_17)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_18)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_23)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_24)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_25)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_26)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_35)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_36)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_37)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_38)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_43)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_44)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_45)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_46)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_47)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_48)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_49)   # 92 86
            FactoryGirl.create(:profile_key, :profile_key9_add_50)   # 92 86
            FactoryGirl.create(:profile_key, :profile_key9_add_51)   # 92 87
            FactoryGirl.create(:profile_key, :profile_key9_add_52)   # 92 87

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
            Name.delete_all
            Name.reset_pk_sequence
            Relation.delete_all
            Relation.reset_pk_sequence
          }

          context '- before action <add_new_profile> - check created data' do
            puts "Before action Add Son_to_Author- data created \n"  #
            it "- Return proper connected_users Array result for current_user_id = 1" do
              expect(connected_users).to eq([9])
            end
          end

          let(:base_profile) {Profile.find(85)}
          let(:base_sex_id) {base_profile.sex_id}
          let(:new_profile_101) { create(:add_profile, :add_profile_101) } # User = nil. Tree = 9. profile_id = 101
          # name_id   419   sex_id    1
          let(:new_relation_id) {3} # Son_to_Author Семен
          let(:exclusions_hash) {{"92" => '0'}}
          let(:tree_ids) {connected_users}

          context '- before action <add_new_profile> - check input params values ' do
            it "- check: base_profile" do
              puts "Check Add Son_to_Author \n"  # 3
              expect(base_profile.id).to eq(85)
            end
            it "- check: base_sex_id" do
              # puts "check base_sex_id: = #{base_sex_id} \n"  # 1
              expect(base_sex_id).to eq(1)
            end
            it "- check: base_profile" do
              # puts "check base_profile.id: = #{base_profile.id} \n"  # ActiveRecord
              expect(base_profile).to be_valid
            end
            it "- check: new_profile_101" do
              # puts "check new_profile_101.id: = #{new_profile_101.id} \n"  # ActiveRecord
              expect(new_profile_101).to be_valid
            end
            it "- check: new_relation_id" do
              # puts "check new_relation_id: = #{new_relation_id} \n"  # 1
              expect(new_relation_id).to eq(3)
            end
            it "- check: exclusions_hash" do
              puts "check exclusions_hash: = #{exclusions_hash} \n"  # 1
              expect(exclusions_hash).to eq({"92" => '0'})
            end
            it "- check: tree_ids" do
              # puts "check tree_ids: = #{tree_ids} \n"  # 1
              expect(tree_ids).to eq([9])
            end
            it '- Tree check have rows count before - Ok' do
              trees_count =  Tree.all.count
              # puts "before action: trees_count = #{trees_count.inspect} \n"
              expect(trees_count).to eq(7) # got 7 rows of Tree - before
            end
            it '- Profile check have rows count & ids before - Ok' do
              profiles_count =  Profile.all.count
              puts "before action: profiles_count = #{profiles_count.inspect} \n"
              expect(profiles_count).to eq(8) # count of Profile
              profiles_ids =  Profile.all.pluck(:id).sort
              puts "before action: profiles_ids = #{profiles_ids.inspect} \n"
              expect(profiles_ids).to eq([85, 86, 87, 88, 89, 90, 91, 92]) # ids of Profiles
            end
            it '- ProfileKey check have rows count & ids before - Ok' do
              profile_keys_count =  ProfileKey.all.count
              puts "before action: profile_keys_count = #{profile_keys_count.inspect} \n"
              expect(profile_keys_count).to eq(52) # count of ProfileKey
              profile_keys_ids =  ProfileKey.all.pluck(:id).sort
              # puts "before action: profile_keys_ids = #{profile_keys_ids.inspect} \n"
              expect(profile_keys_ids).to eq([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
                                              21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38,
                                              39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52]) # ids of ProfileKeys
            end
          end

          context '- After Added Son_to_Author - action <add_new_profile>:' do
            before { ProfileKey.add_new_profile( base_sex_id, base_profile, new_profile_101, new_relation_id,
                                                 exclusions_hash: exclusions_hash_exist, tree_ids: tree_ids_conn ) }
            let(:base_profile) {Profile.find(85)}
            let(:base_sex_id) {base_profile.sex_id}
            # ADD Son_to_Author
            let(:new_profile_101) { create(:add_profile, :add_profile_101) }  # User = nil. Tree = 9. profile_id = 87
            # name_id   419   sex_id    1
            let(:new_relation_id) {3} # Son_to_Author  Семен
            let(:exclusions_hash_exist) {{"92" => '0'}} # Добавляемый Сын - не явл. сыном Жены
            let(:tree_ids_conn) {connected_users}

            it '- check new Tree row - Ok' do
              puts "After ADD Son_to_Author Check Tree \n"
              # puts "In Check Tree: connected_users = #{connected_users}\n"
              # puts "In Check Tree: tree_ids = #{tree_ids}\n"
              new_tree_row = Tree.last
              tree_row_id = new_tree_row.id
              # puts "In check results: tree_row_id = #{tree_row_id} \n"
              expect(tree_row_id).to eq(8) #

              new_user_id = new_tree_row.user_id
              # puts "In check results: new_user_id = #{new_user_id} \n"
              expect(new_user_id).to eq(9) #

              new_profile_id = new_tree_row.profile_id
              # puts "In check results: new_profile_id = #{new_profile_id} \n"
              expect(new_profile_id).to eq(85) #

              new_name_id = new_tree_row.name_id
              # puts "In check results: new_name_id = #{new_name_id} \n"
              expect(new_name_id).to eq(370) #

              new_relation_id = new_tree_row.relation_id
              # puts "In check results: new_relation_id = #{new_relation_id} \n"
              expect(new_relation_id).to eq(3) #

              new_is_profile_id = new_tree_row.is_profile_id
              # puts "In check results: new_is_profile_id = #{new_is_profile_id} \n"
              expect(new_is_profile_id).to eq(101) #

              new_is_name_id = new_tree_row.is_name_id
              # puts "In check results: new_is_name_id = #{new_is_name_id} \n"
              expect(new_is_name_id).to eq(419) #

              new_is_sex_id = new_tree_row.is_sex_id
              # puts "In check results: new_is_sex_id = #{new_is_sex_id} \n"
              expect(new_is_sex_id).to eq(1) #
            end

            it '- check new ProfileKey rows - Ok' do
              profilekeys_count =  ProfileKey.all.count
              puts "After ADD Son_to_Author Check ProfileKey \n"
              puts "In check ProfileKey: profilekeys_count = #{profilekeys_count.inspect} \n"
              expect(profilekeys_count).to eq(66) # got 68 rows of ProfileKey
            end

            it '- check all profile_ids generated in ProfileKey rows - Ok' do
              all_profile_ids =  ProfileKey.all.pluck(:profile_id).sort
              puts "After ADD Son_to_Author Check ProfileKey \n"
              expect(all_profile_ids).to eq([85, 85, 85, 85, 85, 85, 85, 85, 86, 86, 86, 86, 86, 86, 86, 86, 87, 87, 87,
                                             87, 87, 87, 87, 87, 88, 88, 88, 88, 88, 88, 88, 89, 89, 89, 89, 89, 89, 89,
                                             90, 90, 90, 90, 90, 90, 90, 90, 91, 91, 91, 91, 91, 91, 91, 91, 92, 92, 92,
                                             92, 92, 101, 101, 101, 101, 101, 101, 101])
              # expect(all_profile_ids).to eq([85, 88, 85, 89, 88, 89, 85, 90, 88, 90, 89, 90, 85, 91, 90, 91, 88, 91, 89,
              #                                91, 85, 86, 85, 87, 86, 87, 86, 88, 87, 88, 86, 89, 87, 89, 86, 90, 87, 90,
              #                                86, 91, 87, 91, 85, 92, 90, 92, 91, 92, 86, 92, 87, 92, 85, 101, 90, 101,
              #                                91, 101, 86, 101, 87, 101, 88, 101, 89, 101])
              # got all_profile_ids for all rows of ProfileKey
              puts "In check ProfileKey: all_profile_ids = #{all_profile_ids.size} \n"
              expect(all_profile_ids.size).to eq(66)
            end

            it '- check all relations generated in ProfileKey rows - Ok' do
              all_relations =  ProfileKey.all.pluck(:relation_id).sort
              # puts "After ADD Son_to_Author Check ProfileKey \n"
              # puts "In check ProfileKey: all_relations = #{all_relations.inspect} \n"
              expect(all_relations).to eq([1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5,
                                           5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 8, 8, 13, 14, 17, 17, 91, 91, 91, 101, 101,
                                           101, 111, 111, 111, 111, 121, 121, 191, 191, 191, 201, 201, 201, 211, 211,
                                           211, 211, 221, 221]) # got 66 relations of ProfileKey
              puts "In check ProfileKey: all_relations = #{all_relations.size} \n"
              expect(all_relations.size).to eq(66)
            end

            it '- check new Profile rows - Ok' do
              profiles_count =  Profile.all.count
              puts "After ADD Son_to_Author Check Profile \n"
              puts "In check Profile: profiles_count = #{profiles_count.inspect} \n"
              expect(profiles_count).to eq(9) # got 9 rows of Profile
            end
          end
        end

        describe '- Added Daughter - ' do

          before {
            # Tree
            FactoryGirl.create(:tree, :add_tree9_1)   # 86
            FactoryGirl.create(:tree, :add_tree9_2)   # 87
            FactoryGirl.create(:tree, :add_tree9_7)   # 92

            # Profile
            FactoryGirl.create(:add_profile, :add_profile_86)   # 86
            FactoryGirl.create(:add_profile, :add_profile_87)   # 87
            FactoryGirl.create(:add_profile, :add_profile_92)   # 92

            #Profile_Key
            # Before Add new Profile  -  tree #9 Petr
            FactoryGirl.create(:profile_key, :profile_key9_add_1)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_2)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_3)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_4)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_5)   # 86, 87
            FactoryGirl.create(:profile_key, :profile_key9_add_6)   # 86, 87
            FactoryGirl.create(:profile_key, :profile_key9_add_9)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_10)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_11)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_12)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_15)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_16)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_17)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_18)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_23)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_24)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_25)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_26)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_35)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_36)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_37)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_38)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_43)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_44)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_45)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_46)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_47)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_48)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_49)   # 92 86
            FactoryGirl.create(:profile_key, :profile_key9_add_50)   # 92 86
            FactoryGirl.create(:profile_key, :profile_key9_add_51)   # 92 87
            FactoryGirl.create(:profile_key, :profile_key9_add_52)   # 92 87

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
            Name.delete_all
            Name.reset_pk_sequence
            Relation.delete_all
            Relation.reset_pk_sequence
          }

          context '- before action <add_new_profile> - check created data' do
            puts "Before action Add Daughter- data created \n"  #
            it "- Return proper connected_users Array result for current_user_id = 1" do
              expect(connected_users).to eq([9])
            end
          end

          let(:base_profile) {Profile.find(85)}
          let(:base_sex_id) {base_profile.sex_id}
          let(:new_profile_102) { create(:add_profile, :add_profile_102) } # User = nil. Tree = 9. profile_id = 102
          # name_id   412   sex_id    0
          let(:new_relation_id) {4} # Daughter Светлана
          let(:exclusions_hash) {{}}
          let(:tree_ids) {connected_users}

          context '- before action <add_new_profile> - check input params values ' do
            it "- check: base_profile" do
              puts "Check Add Daughter \n"  # 4
              expect(base_profile.id).to eq(85)
            end
            it "- check: base_sex_id" do
              # puts "check base_sex_id: = #{base_sex_id} \n"  # 1
              expect(base_sex_id).to eq(1)
            end
            it "- check: base_profile" do
              # puts "check base_profile.id: = #{base_profile.id} \n"  # ActiveRecord
              expect(base_profile).to be_valid
            end
            it "- check: new_profile_102" do
              # puts "check new_profile_102.id: = #{new_profile_102.id} \n"  # ActiveRecord
              expect(new_profile_102).to be_valid
            end
            it "- check: new_relation_id" do
              # puts "check new_relation_id: = #{new_relation_id} \n"  # 1
              expect(new_relation_id).to eq(4)
            end
            it "- check: exclusions_hash" do
              # puts "check exclusions_hash: = #{exclusions_hash} \n"  # 1
              expect(exclusions_hash).to eq({})
            end
            it "- check: tree_ids" do
              # puts "check tree_ids: = #{tree_ids} \n"  # 1
              expect(tree_ids).to eq([9])
            end
            it '- Tree check have rows count before - Ok' do
              trees_count =  Tree.all.count
              # puts "before action: trees_count = #{trees_count.inspect} \n"
              expect(trees_count).to eq(7) # got 7 rows of Tree - before
            end
            it '- Profile check have rows count & ids before - Ok' do
              profiles_count =  Profile.all.count
              puts "before action: profiles_count = #{profiles_count.inspect} \n"
              expect(profiles_count).to eq(8) # count of Profile
              profiles_ids =  Profile.all.pluck(:id).sort
              puts "before action: profiles_ids = #{profiles_ids.inspect} \n"
              expect(profiles_ids).to eq([85, 86, 87, 88, 89, 90, 91, 92]) # ids of Profiles
            end
            it '- ProfileKey check have rows count & ids before - Ok' do
              profile_keys_count =  ProfileKey.all.count
              puts "before action: profile_keys_count = #{profile_keys_count.inspect} \n"
              expect(profile_keys_count).to eq(52) # count of ProfileKey
              profile_keys_ids =  ProfileKey.all.pluck(:id).sort
              # puts "before action: profile_keys_ids = #{profile_keys_ids.inspect} \n"
              expect(profile_keys_ids).to eq([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
                                              21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38,
                                              39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52]) # ids of ProfileKeys
            end
          end

          context '- After Added Daughter - action <add_new_profile>:' do
            before { ProfileKey.add_new_profile( base_sex_id, base_profile, new_profile_102, new_relation_id,
                                                 exclusions_hash: exclusions_hash_empty, tree_ids: tree_ids_conn ) }
            let(:base_profile) {Profile.find(85)}
            let(:base_sex_id) {base_profile.sex_id}
            # ADD Son
            let(:new_profile_102) { create(:add_profile, :add_profile_102) }  # User = nil. Tree = 9. profile_id = 102
            # name_id   412   sex_id    1
            let(:new_relation_id) {4} # Daughter
            let(:exclusions_hash_empty) {{}}
            let(:tree_ids_conn) {connected_users}

            it '- check new Tree row - Ok' do
              puts "After ADD Daughter Check Tree \n"
              # puts "In Check Tree: connected_users = #{connected_users}\n"
              # puts "In Check Tree: tree_ids = #{tree_ids}\n"
              new_tree_row = Tree.last
              tree_row_id = new_tree_row.id
              # puts "In check results: tree_row_id = #{tree_row_id} \n"
              expect(tree_row_id).to eq(8) #

              new_user_id = new_tree_row.user_id
              # puts "In check results: new_user_id = #{new_user_id} \n"
              expect(new_user_id).to eq(9) #

              new_profile_id = new_tree_row.profile_id
              # puts "In check results: new_profile_id = #{new_profile_id} \n"
              expect(new_profile_id).to eq(85) #

              new_name_id = new_tree_row.name_id
              # puts "In check results: new_name_id = #{new_name_id} \n"
              expect(new_name_id).to eq(370) #

              new_relation_id = new_tree_row.relation_id
              # puts "In check results: new_relation_id = #{new_relation_id} \n"
              expect(new_relation_id).to eq(4) #

              new_is_profile_id = new_tree_row.is_profile_id
              # puts "In check results: new_is_profile_id = #{new_is_profile_id} \n"
              expect(new_is_profile_id).to eq(102) #

              new_is_name_id = new_tree_row.is_name_id
              # puts "In check results: new_is_name_id = #{new_is_name_id} \n"
              expect(new_is_name_id).to eq(412) #

              new_is_sex_id = new_tree_row.is_sex_id
              # puts "In check results: new_is_sex_id = #{new_is_sex_id} \n"
              expect(new_is_sex_id).to eq(0) #
            end

            it '- check new ProfileKey rows - Ok' do
              profilekeys_count =  ProfileKey.all.count
              puts "After ADD Daughter Check ProfileKey \n"
              puts "In check ProfileKey: profilekeys_count = #{profilekeys_count.inspect} \n"
              expect(profilekeys_count).to eq(68) # got 68 rows of ProfileKey
            end

            it '- check all name_ids generated in ProfileKey rows - Ok' do
              all_name_ids =  ProfileKey.all.pluck(:name_id).sort
              puts "After ADD Daughter Check ProfileKey \n"
              # expect(all_name_ids).to eq([370, 465, 370, 345, 465, 345, 370, 343, 465, 343, 345, 343, 370, 446, 343,
              #                             446, 465, 446, 345, 446, 370, 28, 370, 48, 28, 48, 28, 465, 48, 465, 28, 345,
              #                             48, 345, 28, 343, 48, 343, 28, 446, 48, 446, 370, 147, 343, 147, 446, 147,
              #                             28, 147, 48, 147, 370, 412, 147, 412, 343, 412, 446, 412, 28, 412, 48, 412,
              #                             465, 412, 345, 412])
              expect(all_name_ids).to eq([28, 28, 28, 28, 28, 28, 28, 28, 48, 48, 48, 48, 48, 48, 48, 48, 147, 147, 147,
                                          147, 147, 147, 343, 343, 343, 343, 343, 343, 343, 343, 345, 345, 345, 345,
                                          345, 345, 345, 370, 370, 370, 370, 370, 370, 370, 370, 412, 412, 412, 412,
                                          412, 412, 412, 412, 446, 446, 446, 446, 446, 446, 446, 446, 465, 465, 465,
                                          465, 465, 465, 465])
              # got all_name_ids for all rows of ProfileKey
              puts "In check ProfileKey: all_name_ids = #{all_name_ids.size} \n"
              expect(all_name_ids.size).to eq(68)
            end

            it '- check all relations generated in ProfileKey rows - Ok' do
              all_relations =  ProfileKey.all.pluck(:relation_id).sort
              # puts "After ADD Daughter Check ProfileKey \n"
              # puts "In check ProfileKey: all_relations = #{all_relations.inspect} \n"
              expect(all_relations).to eq([1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 5, 5,
                                           5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 7, 7, 8, 8, 13, 14, 17, 17, 91, 91, 91, 101,
                                           101, 101, 111, 111, 121, 121, 121, 121, 191, 191, 191, 201, 201, 201, 211,
                                           211, 221, 221, 221, 221]) # got 52 relations of ProfileKey
              puts "In check ProfileKey: all_relations = #{all_relations.size} \n"
              expect(all_relations.size).to eq(68)
            end

            it '- check new Profile rows - Ok' do
              profiles_count =  Profile.all.count
              puts "After ADD Daughter Check Profile \n"
              puts "In check Profile: profiles_count = #{profiles_count.inspect} \n"
              expect(profiles_count).to eq(9) # got 9 rows of Profile
            end
          end
        end


        describe '- Added Brother - ' do
          before {
            # Tree
            FactoryGirl.create(:tree, :add_tree9_1)   # 86
            FactoryGirl.create(:tree, :add_tree9_2)   # 87
            FactoryGirl.create(:tree, :add_tree9_7)   # 92

            # Profile
            FactoryGirl.create(:add_profile, :add_profile_86)   # 86
            FactoryGirl.create(:add_profile, :add_profile_87)   # 87
            FactoryGirl.create(:add_profile, :add_profile_92)   # 92

            #Profile_Key
            # Before Add new Profile  -  tree #9 Petr
            FactoryGirl.create(:profile_key, :profile_key9_add_1)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_2)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_3)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_4)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_5)   # 86, 87
            FactoryGirl.create(:profile_key, :profile_key9_add_6)   # 86, 87
            FactoryGirl.create(:profile_key, :profile_key9_add_9)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_10)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_11)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_12)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_15)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_16)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_17)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_18)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_23)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_24)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_25)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_26)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_35)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_36)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_37)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_38)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_43)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_44)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_45)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_46)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_47)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_48)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_49)   # 92 86
            FactoryGirl.create(:profile_key, :profile_key9_add_50)   # 92 86
            FactoryGirl.create(:profile_key, :profile_key9_add_51)   # 92 87
            FactoryGirl.create(:profile_key, :profile_key9_add_52)   # 92 87

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
            Name.delete_all
            Name.reset_pk_sequence
            Relation.delete_all
            Relation.reset_pk_sequence
          }

          context '- before action <add_new_profile> - check created data' do
            puts "Before action Add Brother- data created \n"  #
            it "- Return proper connected_users Array result for current_user_id = 1" do
              expect(connected_users).to eq([9])
            end
          end

          let(:base_profile) {Profile.find(85)}
          let(:base_sex_id) {base_profile.sex_id}
          let(:new_profile_101) { create(:add_profile, :add_profile_101) } # User = nil. Tree = 9. profile_id = 101
          # name_id   419   sex_id    1
          let(:new_relation_id) {5} # Brother Семен
          let(:exclusions_hash) {{}}
          let(:tree_ids) {connected_users}

          context '- before action <add_new_profile> - check input params values ' do
            it "- check: base_profile" do
              puts "Check Add Brother \n"  # 5
              expect(base_profile.id).to eq(85)
            end
            it "- check: base_sex_id" do
              # puts "check base_sex_id: = #{base_sex_id} \n"  # 1
              expect(base_sex_id).to eq(1)
            end
            it "- check: base_profile" do
              # puts "check base_profile.id: = #{base_profile.id} \n"  # ActiveRecord
              expect(base_profile).to be_valid
            end
            it "- check: new_profile_101" do
              # puts "check new_profile_101.id: = #{new_profile_101.id} \n"  # ActiveRecord
              expect(new_profile_101).to be_valid
            end
            it "- check: new_relation_id" do
              # puts "check new_relation_id: = #{new_relation_id} \n"  # 1
              expect(new_relation_id).to eq(5)
            end
            it "- check: exclusions_hash" do
              # puts "check exclusions_hash: = #{exclusions_hash} \n"  # 1
              expect(exclusions_hash).to eq({})
            end
            it "- check: tree_ids" do
              # puts "check tree_ids: = #{tree_ids} \n"  # 1
              expect(tree_ids).to eq([9])
            end
            it '- Tree check have rows count before - Ok' do
              trees_count =  Tree.all.count
              # puts "before action: trees_count = #{trees_count.inspect} \n"
              expect(trees_count).to eq(7) # got 7 rows of Tree - before
            end
            it '- Profile check have rows count & ids before - Ok' do
              profiles_count =  Profile.all.count
              puts "before action: profiles_count = #{profiles_count.inspect} \n"
              expect(profiles_count).to eq(8) # count of Profile
              profiles_ids =  Profile.all.pluck(:id).sort
              puts "before action: profiles_ids = #{profiles_ids.inspect} \n"
              expect(profiles_ids).to eq([85, 86, 87, 88, 89, 90, 91, 92]) # ids of Profiles
            end
            it '- ProfileKey check have rows count & ids before - Ok' do
              profile_keys_count =  ProfileKey.all.count
              puts "before action: profile_keys_count = #{profile_keys_count.inspect} \n"
              expect(profile_keys_count).to eq(52) # count of ProfileKey
              profile_keys_ids =  ProfileKey.all.pluck(:id).sort
              # puts "before action: profile_keys_ids = #{profile_keys_ids.inspect} \n"
              expect(profile_keys_ids).to eq([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
                                              21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38,
                                              39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52]) # ids of ProfileKeys
            end
          end

          context '- After Added Brother - action <add_new_profile>:' do
            before { ProfileKey.add_new_profile( base_sex_id, base_profile, new_profile_101, new_relation_id,
                                                 exclusions_hash: exclusions_hash_empty, tree_ids: tree_ids_conn ) }
            let(:base_profile) {Profile.find(85)}
            let(:base_sex_id) {base_profile.sex_id}
            # ADD Son
            let(:new_profile_101) { create(:add_profile, :add_profile_101) }  # User = nil. Tree = 9. profile_id = 101
            # name_id   419   sex_id    1
            let(:new_relation_id) {5} # Brother
            let(:exclusions_hash_empty) {{}}
            let(:tree_ids_conn) {connected_users}

            it '- check new Tree row - Ok' do
              puts "After ADD Brother Check Tree \n"
              # puts "In Check Tree: connected_users = #{connected_users}\n"
              # puts "In Check Tree: tree_ids = #{tree_ids}\n"
              new_tree_row = Tree.last
              tree_row_id = new_tree_row.id
              # puts "In check results: tree_row_id = #{tree_row_id} \n"
              expect(tree_row_id).to eq(8) #

              new_user_id = new_tree_row.user_id
              # puts "In check results: new_user_id = #{new_user_id} \n"
              expect(new_user_id).to eq(9) #

              new_profile_id = new_tree_row.profile_id
              # puts "In check results: new_profile_id = #{new_profile_id} \n"
              expect(new_profile_id).to eq(85) #

              new_name_id = new_tree_row.name_id
              # puts "In check results: new_name_id = #{new_name_id} \n"
              expect(new_name_id).to eq(370) #

              new_relation_id = new_tree_row.relation_id
              # puts "In check results: new_relation_id = #{new_relation_id} \n"
              expect(new_relation_id).to eq(5) #

              new_is_profile_id = new_tree_row.is_profile_id
              # puts "In check results: new_is_profile_id = #{new_is_profile_id} \n"
              expect(new_is_profile_id).to eq(101) #

              new_is_name_id = new_tree_row.is_name_id
              # puts "In check results: new_is_name_id = #{new_is_name_id} \n"
              expect(new_is_name_id).to eq(419) #

              new_is_sex_id = new_tree_row.is_sex_id
              # puts "In check results: new_is_sex_id = #{new_is_sex_id} \n"
              expect(new_is_sex_id).to eq(1) #
            end

            it '- check new ProfileKey rows - Ok' do
              profilekeys_count =  ProfileKey.all.count
              puts "After ADD Brother Check ProfileKey \n"
              puts "In check ProfileKey: profilekeys_count = #{profilekeys_count.inspect} \n"
              expect(profilekeys_count).to eq(66) # got 66 rows of ProfileKey
            end

            it '- check all is_profile_id generated in ProfileKey rows - Ok' do
              all_is_profile_ids =  ProfileKey.all.pluck(:is_profile_id).sort
              puts "After ADD Brother Check ProfileKey \n"
              # expect(all_is_profile_ids).to eq([88, 85, 89, 85, 89, 88, 90, 85, 90, 88, 90, 89, 91, 85, 91, 90, 91, 88,
              #                                   91, 89, 86, 85, 87, 85, 87, 86, 88, 86, 88, 87, 89, 86, 89, 87, 90, 86,
              #                                   90, 87, 91, 86, 91, 87, 92, 85, 92, 90, 92, 91, 92, 86, 92, 87, 101, 85,
              #                                   101, 86, 101, 87, 101, 88, 101, 89, 101, 90, 101, 91])
              expect(all_is_profile_ids).to eq([85, 85, 85, 85, 85, 85, 85, 85, 86, 86, 86, 86, 86, 86, 86, 86, 87, 87,
                                                87, 87, 87, 87, 87, 87, 88, 88, 88, 88, 88, 88, 88, 89, 89, 89, 89, 89,
                                                89, 89, 90, 90, 90, 90, 90, 90, 90, 90, 91, 91, 91, 91, 91, 91, 91, 91,
                                                92, 92, 92, 92, 92, 101, 101, 101, 101, 101, 101, 101])
              # got all_is_profile_ids for all rows of ProfileKey
              puts "In check ProfileKey: all_is_profile_ids = #{all_is_profile_ids.size} \n"
              expect(all_is_profile_ids.size).to eq(66)
            end

            it '- check all relations generated in ProfileKey rows - Ok' do
              all_relations =  ProfileKey.all.pluck(:relation_id).sort
              # puts "After ADD Brother Check ProfileKey \n"
              # puts "In check ProfileKey: all_relations = #{all_relations.inspect} \n"
              expect(all_relations).to eq([1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5,
                                           5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 8, 8, 13, 14, 17, 17, 91, 91, 101,
                                           101, 111, 111, 121, 121, 191, 191, 191, 191, 201, 201, 211, 211, 211, 221,
                                           221, 221]) # got 66 relations of ProfileKey
              puts "In check ProfileKey: all_relations = #{all_relations.size} \n"
              expect(all_relations.size).to eq(66)
            end

            it '- check new Profile rows - Ok' do
              profiles_count =  Profile.all.count
              puts "After ADD Brother Check Profile \n"
              puts "In check Profile: profiles_count = #{profiles_count.inspect} \n"
              expect(profiles_count).to eq(9) # got 9 rows of Profile
            end
          end


        end

        describe '- Added Sister - ' do
          before {
            # Tree
            FactoryGirl.create(:tree, :add_tree9_1)   # 86
            FactoryGirl.create(:tree, :add_tree9_2)   # 87
            FactoryGirl.create(:tree, :add_tree9_7)   # 92

            # Profile
            FactoryGirl.create(:add_profile, :add_profile_86)   # 86
            FactoryGirl.create(:add_profile, :add_profile_87)   # 87
            FactoryGirl.create(:add_profile, :add_profile_92)   # 92

            #Profile_Key
            # Before Add new Profile  -  tree #9 Petr
            FactoryGirl.create(:profile_key, :profile_key9_add_1)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_2)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_3)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_4)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_5)   # 86, 87
            FactoryGirl.create(:profile_key, :profile_key9_add_6)   # 86, 87
            FactoryGirl.create(:profile_key, :profile_key9_add_9)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_10)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_11)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_12)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_15)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_16)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_17)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_18)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_23)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_24)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_25)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_26)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_35)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_36)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_37)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_38)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_43)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_44)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_45)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_46)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_47)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_48)   # 92
            FactoryGirl.create(:profile_key, :profile_key9_add_49)   # 92 86
            FactoryGirl.create(:profile_key, :profile_key9_add_50)   # 92 86
            FactoryGirl.create(:profile_key, :profile_key9_add_51)   # 92 87
            FactoryGirl.create(:profile_key, :profile_key9_add_52)   # 92 87

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
            Name.delete_all
            Name.reset_pk_sequence
            Relation.delete_all
            Relation.reset_pk_sequence
          }

          context '- before action <add_new_profile> - check created data' do
            puts "Before action Add Sister- data created \n"  #
            it "- Return proper connected_users Array result for current_user_id = 1" do
              expect(connected_users).to eq([9])
            end
          end

          let(:base_profile) {Profile.find(85)}
          let(:base_sex_id) {base_profile.sex_id}
          let(:new_profile_102) { create(:add_profile, :add_profile_102) } # User = nil. Tree = 9. profile_id = 102
          # name_id   412   sex_id    0
          let(:new_relation_id) {6} # Sister Светлана
          let(:exclusions_hash) {{}}
          let(:tree_ids) {connected_users}

          context '- before action <add_new_profile> - check input params values ' do
            it "- check: base_profile" do
              puts "Check Add Sister \n"  # 6
              expect(base_profile.id).to eq(85)
            end
            it "- check: base_sex_id" do
              # puts "check base_sex_id: = #{base_sex_id} \n"  # 1
              expect(base_sex_id).to eq(1)
            end
            it "- check: base_profile" do
              # puts "check base_profile.id: = #{base_profile.id} \n"  # ActiveRecord
              expect(base_profile).to be_valid
            end
            it "- check: new_profile_102" do
              # puts "check new_profile_102.id: = #{new_profile_102.id} \n"  # ActiveRecord
              expect(new_profile_102).to be_valid
            end
            it "- check: new_relation_id" do
              # puts "check new_relation_id: = #{new_relation_id} \n"  # 1
              expect(new_relation_id).to eq(6)
            end
            it "- check: exclusions_hash" do
              # puts "check exclusions_hash: = #{exclusions_hash} \n"  # 1
              expect(exclusions_hash).to eq({})
            end
            it "- check: tree_ids" do
              # puts "check tree_ids: = #{tree_ids} \n"  # 1
              expect(tree_ids).to eq([9])
            end
            it '- Tree check have rows count before - Ok' do
              trees_count =  Tree.all.count
              # puts "before action: trees_count = #{trees_count.inspect} \n"
              expect(trees_count).to eq(7) # got 7 rows of Tree - before
            end
            it '- Profile check have rows count & ids before - Ok' do
              profiles_count =  Profile.all.count
              puts "before action: profiles_count = #{profiles_count.inspect} \n"
              expect(profiles_count).to eq(8) # count of Profile
              profiles_ids =  Profile.all.pluck(:id).sort
              puts "before action: profiles_ids = #{profiles_ids.inspect} \n"
              expect(profiles_ids).to eq([85, 86, 87, 88, 89, 90, 91, 92]) # ids of Profiles
            end

            describe '- check ProfileKey count values' do   # , focus: true
              let(:rows_qty) {52}
              let(:rows_ids_arr) {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
                                   21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38,
                                   39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52]}
              it_behaves_like :successful_profile_keys_ids
            end


          end

          context '- After Added Sister - action <add_new_profile>:' do
            before { ProfileKey.add_new_profile( base_sex_id, base_profile, new_profile_102, new_relation_id,
                                                 exclusions_hash: exclusions_hash_empty, tree_ids: tree_ids_conn ) }
            let(:base_profile) {Profile.find(85)}
            let(:base_sex_id) {base_profile.sex_id}
            # ADD Son
            let(:new_profile_102) { create(:add_profile, :add_profile_102) }  # User = nil. Tree = 9. profile_id = 102
            # name_id   412   sex_id    0
            let(:new_relation_id) {6} # Brother
            let(:exclusions_hash_empty) {{}}
            let(:tree_ids_conn) {connected_users}

            it '- check new Tree row - Ok' do
              puts "After ADD Sister Check Tree \n"
              # puts "In Check Tree: connected_users = #{connected_users}\n"
              # puts "In Check Tree: tree_ids = #{tree_ids}\n"
              new_tree_row = Tree.last
              tree_row_id = new_tree_row.id
              # puts "In check results: tree_row_id = #{tree_row_id} \n"
              expect(tree_row_id).to eq(8) #

              new_user_id = new_tree_row.user_id
              # puts "In check results: new_user_id = #{new_user_id} \n"
              expect(new_user_id).to eq(9) #

              new_profile_id = new_tree_row.profile_id
              # puts "In check results: new_profile_id = #{new_profile_id} \n"
              expect(new_profile_id).to eq(85) #

              new_name_id = new_tree_row.name_id
              # puts "In check results: new_name_id = #{new_name_id} \n"
              expect(new_name_id).to eq(370) #

              new_relation_id = new_tree_row.relation_id
              # puts "In check results: new_relation_id = #{new_relation_id} \n"
              expect(new_relation_id).to eq(6) #

              new_is_profile_id = new_tree_row.is_profile_id
              # puts "In check results: new_is_profile_id = #{new_is_profile_id} \n"
              expect(new_is_profile_id).to eq(102) #

              new_is_name_id = new_tree_row.is_name_id
              # puts "In check results: new_is_name_id = #{new_is_name_id} \n"
              expect(new_is_name_id).to eq(412) #

              new_is_sex_id = new_tree_row.is_sex_id
              # puts "In check results: new_is_sex_id = #{new_is_sex_id} \n"
              expect(new_is_sex_id).to eq(0) #
            end

            it '- check new ProfileKey rows - Ok' do
              profilekeys_count =  ProfileKey.all.count
              puts "After ADD Sister Check ProfileKey \n"
              puts "In check ProfileKey: profilekeys_count = #{profilekeys_count.inspect} \n"
              expect(profilekeys_count).to eq(66) # got 66 rows of ProfileKey
            end

            it '- check all is_name_ids generated in ProfileKey rows - Ok' do
              all_is_name_ids =  ProfileKey.all.pluck(:is_name_id).sort
              puts "After ADD Sister Check ProfileKey \n"
              # expect(all_is_name_ids).to eq([465, 370, 345, 370, 345, 465, 343, 370, 343, 465, 343, 345, 446, 370, 446,
              #                                343, 446, 465, 446, 345, 28, 370, 48, 370, 48, 28, 465, 28, 465, 48, 345,
              #                                28, 345, 48, 343, 28, 343, 48, 446, 28, 446, 48, 147, 370, 147, 343, 147,
              #                                446, 147, 28, 147, 48, 412, 370, 412, 28, 412, 48, 412, 465, 412, 345,
              #                                412, 343, 412, 446])
              expect(all_is_name_ids).to eq([28, 28, 28, 28, 28, 28, 28, 28, 48, 48, 48, 48, 48, 48, 48, 48, 147, 147,
                                             147, 147, 147, 343, 343, 343, 343, 343, 343, 343, 343, 345, 345, 345, 345,
                                             345, 345, 345, 370, 370, 370, 370, 370, 370, 370, 370, 412, 412, 412, 412,
                                             412, 412, 412, 446, 446, 446, 446, 446, 446, 446, 446, 465, 465, 465, 465,
                                             465, 465, 465])
              # got all_is_name_ids for all rows of ProfileKey
              puts "In check ProfileKey: all_is_name_ids = #{all_is_name_ids.size} \n"
              expect(all_is_name_ids.size).to eq(66)
            end

            it '- check all relations generated in ProfileKey rows - Ok' do
              all_relations =  ProfileKey.all.pluck(:relation_id).sort
              # puts "After ADD Sister Check ProfileKey \n"
              # puts "In check ProfileKey: all_relations = #{all_relations.inspect} \n"
              expect(all_relations).to eq([1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 5, 5,
                                           5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 7, 7, 8, 8, 13, 14, 17, 17, 91, 91, 101,
                                           101, 111, 111, 121, 121, 191, 191, 201, 201, 201, 201, 211, 211, 211, 221,
                                           221, 221]) # got 66 relations of ProfileKey
              puts "In check ProfileKey: all_relations = #{all_relations.size} \n"
              expect(all_relations.size).to eq(66)
            end

            it '- check new Profile rows - Ok' do
              profiles_count =  Profile.all.count
              puts "After ADD Sister Check Profile \n"
              puts "In check Profile: profiles_count = #{profiles_count.inspect} \n"
              expect(profiles_count).to eq(9) # got 9 rows of Profile
            end
          end

        end

        describe '- Added Wife - ' do
          before {
            # Tree
            FactoryGirl.create(:tree, :add_tree9_2)   # 87
            FactoryGirl.create(:tree, :add_tree9_1)   # 96

            # Profile
            FactoryGirl.create(:add_profile, :add_profile_87)   # 87
            FactoryGirl.create(:add_profile, :add_profile_86)   # 86

            #Profile_Key
            # Before Add new Profile  -  tree #9 Petr
            FactoryGirl.create(:profile_key, :profile_key9_add_1)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_2)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_3)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_4)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_5)   # 86, 87
            FactoryGirl.create(:profile_key, :profile_key9_add_6)   # 86, 87
            FactoryGirl.create(:profile_key, :profile_key9_add_9)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_10)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_11)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_12)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_15)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_16)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_17)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_18)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_23)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_24)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_25)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_26)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_35)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_36)   # 86
            FactoryGirl.create(:profile_key, :profile_key9_add_37)   # 87
            FactoryGirl.create(:profile_key, :profile_key9_add_38)   # 87
            # FactoryGirl.create(:profile_key, :profile_key9_add_43)   # 92
            # FactoryGirl.create(:profile_key, :profile_key9_add_44)   # 92
            # FactoryGirl.create(:profile_key, :profile_key9_add_45)   # 92
            # FactoryGirl.create(:profile_key, :profile_key9_add_46)   # 92
            # FactoryGirl.create(:profile_key, :profile_key9_add_47)   # 92
            # FactoryGirl.create(:profile_key, :profile_key9_add_48)   # 92
            # # FactoryGirl.create(:profile_key, :profile_key9_add_49)   # 92 86
            # # FactoryGirl.create(:profile_key, :profile_key9_add_50)   # 92 86
            # FactoryGirl.create(:profile_key, :profile_key9_add_51)   # 92 87
            # FactoryGirl.create(:profile_key, :profile_key9_add_52)   # 92 87

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
            Relation.delete_all
            Relation.reset_pk_sequence
          }

          context '- before action <add_new_profile> - check created data' do
            puts "Before action Add Wife- data created \n"  #
            it "- Return proper connected_users Array result for current_user_id = 1" do
              expect(connected_users).to eq([9])
            end
          end

          let(:base_profile) {Profile.find(85)}
          let(:base_sex_id) {base_profile.sex_id}
          let(:new_profile_92) { create(:add_profile, :add_profile_92) } # User = nil. Tree = 9. profile_id = 92
          # name_id   147   sex_id    1
          let(:new_relation_id) {8} # Wife
          let(:exclusions_hash) {{}}
          let(:tree_ids) {connected_users}

          context '- before action <add_new_profile> - check input params values ' do
            it "- check: base_profile" do
              puts "Check Add Wife \n"  # 8
              expect(base_profile.id).to eq(85)
            end
            it "- check: base_sex_id" do
              # puts "check base_sex_id: = #{base_sex_id} \n"  # 1
              expect(base_sex_id).to eq(1)
            end
            it "- check: base_profile" do
              # puts "check base_profile.id: = #{base_profile.id} \n"  # ActiveRecord
              expect(base_profile).to be_valid
            end
            it "- check: new_profile_92" do
              # puts "check new_profile_92.id: = #{new_profile_92.id} \n"  # ActiveRecord
              expect(new_profile_92).to be_valid
            end
            it "- check: new_relation_id" do
              # puts "check new_relation_id: = #{new_relation_id} \n"  # 8
              expect(new_relation_id).to eq(8)
            end
            it "- check: exclusions_hash" do
              # puts "check exclusions_hash: = #{exclusions_hash} \n"  #
              expect(exclusions_hash).to eq({})
            end
            it "- check: tree_ids" do
              # puts "check tree_ids: = #{tree_ids} \n"  #
              expect(tree_ids).to eq([9])
            end
            it '- Tree check have rows count before - Ok' do
              trees_count =  Tree.all.count
              # puts "before action: trees_count = #{trees_count.inspect} \n"
              expect(trees_count).to eq(6) # got 82 rows of Tree
            end
            it '- Profile check have rows count & ids before - Ok' do
              profiles_count =  Profile.all.count
              puts "before action: profiles_count = #{profiles_count.inspect} \n"
              expect(profiles_count).to eq(7) # count of Profile
              profiles_ids =  Profile.all.pluck(:id).sort
              puts "before action: profiles_ids = #{profiles_ids.inspect} \n"
              expect(profiles_ids).to eq([85, 86, 87, 88, 89, 90, 91]) # ids of Profiles
              # puts "before All: base_profile.id = #{base_profile.id} \n"  # id = 85
              # puts "before All: base_profile.user_id = #{base_profile.user_id} \n"  # id = 9
            end

            describe '- check ProfileKey count values' do
              let(:rows_qty) {42}
              let(:rows_ids_arr) {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
                                   22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
                                   40, 41, 42]}
              it_behaves_like :successful_profile_keys_ids
            end

          end

          context '- After ADD Wife - action <add_new_profile>:' do
            before { ProfileKey.add_new_profile( base_sex_id, base_profile, new_profile_92, new_relation_id,
                                                 exclusions_hash: exclusions_hash_empty, tree_ids: tree_ids_conn ) }

            let(:base_profile) {Profile.find(85)}
            let(:base_sex_id) {base_profile.sex_id}
            # ADD Wife
            let(:new_profile_92) { create(:add_profile, :add_profile_92) }  # User = nil. Tree = 9. profile_id = 92
            # name_id   147   sex_id    0
            let(:new_relation_id) {8} # Wife
            let(:exclusions_hash_empty) {{}}
            let(:tree_ids_conn) {connected_users}

            it '- check new Tree row - Ok' do
              puts "After ADD Wife Check Tree \n"
              # puts "In Check Tree: connected_users = #{connected_users}\n"
              # puts "In Check Tree: tree_ids = #{tree_ids}\n"
              # [85, 1, 370, nil, 1, 86, 28, nil]
              new_tree_row = Tree.last
              tree_row_id = new_tree_row.id
              # puts "In check results: tree_row_id = #{tree_row_id} \n"
              expect(tree_row_id).to eq(7) #

              new_user_id = new_tree_row.user_id
              # puts "In check results: new_user_id = #{new_user_id} \n"
              expect(new_user_id).to eq(9) #

              new_profile_id = new_tree_row.profile_id
              # puts "In check results: new_profile_id = #{new_profile_id} \n"
              expect(new_profile_id).to eq(85) #

              new_name_id = new_tree_row.name_id
              # puts "In check results: new_name_id = #{new_name_id} \n"
              expect(new_name_id).to eq(370) #

              new_relation_id = new_tree_row.relation_id
              # puts "In check results: new_relation_id = #{new_relation_id} \n"
              expect(new_relation_id).to eq(8) #

              new_is_profile_id = new_tree_row.is_profile_id
              # puts "In check results: new_is_profile_id = #{new_is_profile_id} \n"
              expect(new_is_profile_id).to eq(92) #

              new_is_name_id = new_tree_row.is_name_id
              # puts "In check results: new_is_name_id = #{new_is_name_id} \n"
              expect(new_is_name_id).to eq(147) #

              new_is_sex_id = new_tree_row.is_sex_id
              # puts "In check results: new_is_sex_id = #{new_is_sex_id} \n"
              expect(new_is_sex_id).to eq(0) #
            end

            it '- check new ProfileKey rows - Ok' do
              profilekeys_count =  ProfileKey.all.count
              puts "After ADD Wife Check ProfileKey \n"
              puts "In check ProfileKey: profilekeys_count = #{profilekeys_count.inspect} \n"
              expect(profilekeys_count).to eq(52) # got 52 rows of ProfileKey
            end

            it '- check all relations generated in ProfileKey rows - Ok' do
              all_relations =  ProfileKey.all.pluck(:relation_id).sort
              puts "After ADD Wife Check ProfileKey \n"
              # puts "In check ProfileKey: all_relations = #{all_relations.inspect} \n"
              expect(all_relations).to eq([1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5, 6,
                                           6, 6, 7, 7, 8, 8, 13, 14, 17, 17, 91, 91, 101, 101, 111, 111, 121, 121, 191,
                                           191, 201, 201, 211, 211, 221, 221]) # got 52 relations of ProfileKey
              puts "In check ProfileKey: all_relations = #{all_relations.size} \n"
              expect(all_relations.size).to eq(52)
            end

            it '- check new Profile rows - Ok' do
              profiles_count =  Profile.all.count
              puts "After ADD Wife Check Profile \n"
              puts "In check Profile: profiles_count = #{profiles_count.inspect} \n"
              expect(profiles_count).to eq(8) # got 8 rows of Profile
            end
          end

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
