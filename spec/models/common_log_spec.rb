require 'rails_helper'

RSpec.describe CommonLog, type: :model do

  describe '- validation' do
    describe '- on create' do

      context '- valid common_log_row' do
        let(:common_log_row) {FactoryGirl.build(:common_log)}  #
        it '- saves a valid common_log_row' do
          puts "Model CommonLog validation "
          expect(common_log_row).to be_valid
        end
      end

      context '- invalid common_log_row' do
        let(:bad_type_number) {FactoryGirl.build(:common_log, :uncorrect_type)}
        it '- 1 Dont save: - bad_type_number - out of range' do
          expect(bad_type_number).to_not be_valid
        end

        let(:bad_user) {FactoryGirl.build(:common_log, :uncorrect_user)}
        it '- 2 Dont save: - bad_user - uninteger' do
          expect(bad_user).to_not be_valid
        end

        let(:bad_uncorrect_log_id) {FactoryGirl.build(:common_log, :uncorrect_log_id)}
        it '- 3 Dont save: - bad_log_id - uninteger' do
          expect(bad_uncorrect_log_id).to_not be_valid
        end

        let(:bad_uncorrect_profile) {FactoryGirl.build(:common_log, :uncorrect_profile)}
        it '- 4 Dont save: - bad_log_id - uninteger' do
          expect(bad_uncorrect_profile).to_not be_valid
        end

        let(:bad_uncorrect_base_profile) {FactoryGirl.build(:common_log, :uncorrect_base_profile)}
        it '- 5 Dont save: - uncorrect_base_profile - uninteger' do
          expect(bad_uncorrect_base_profile).to_not be_valid
        end

        let(:bad_uncorrect_relation_id_1) {FactoryGirl.build(:common_log, :uncorrect_relation_id_1)}
        it '- 6 Dont save: - bad_relation_id - uninteger' do
          expect(bad_uncorrect_relation_id_1).to_not be_valid
        end

        let(:bad_uncorrect_relation_id_2) {FactoryGirl.build(:common_log, :uncorrect_relation_id_2)}
        it '- 7 Dont save: - bad_relation_id - not in range' do
          expect(bad_uncorrect_relation_id_2).to_not be_valid
        end
      end

    end
  end

  # pending "add some examples to (or delete) #{__FILE__}"
  describe '- CHECK CommonLog Model methods' do

    # create model data
    before {
      #Name -  # before
      FactoryGirl.create(:name, :name_28)    # Алексей
      FactoryGirl.create(:name, :name_48)    # Анна
      FactoryGirl.create(:name, :name_82)    # Валентина
      FactoryGirl.create(:name, :name_122)   # Вячеслав
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

      # ConnectedUser
      FactoryGirl.create(:connected_user, :correct)      # 1  2
      FactoryGirl.create(:connected_user, :correct_3_4)  # 3  4

      # Profile
      FactoryGirl.create(:add_profile, :add_profile_85)   # 85
      FactoryGirl.create(:add_profile, :add_profile_86)   # 86
      FactoryGirl.create(:add_profile, :add_profile_87)   # 87
      FactoryGirl.create(:add_profile, :add_profile_88) # before
      FactoryGirl.create(:add_profile, :add_profile_89) # before
      FactoryGirl.create(:add_profile, :add_profile_90) # before
      FactoryGirl.create(:add_profile, :add_profile_91) # before
      FactoryGirl.create(:add_profile, :add_profile_92)   # 92
      # FactoryGirl.create(:profile, :add_profile_93) # user_10 # before
      # FactoryGirl.create(:profile, :add_profile_94)
      # FactoryGirl.create(:profile, :add_profile_95)
      # FactoryGirl.create(:profile, :add_profile_96) # before
      # FactoryGirl.create(:profile, :add_profile_97) # before
      # FactoryGirl.create(:profile, :add_profile_98) # before
      # FactoryGirl.create(:profile, :add_profile_99) # before
      # FactoryGirl.create(:profile, :add_profile_100)
      FactoryGirl.create(:add_profile, :add_profile_172)   # 172
      FactoryGirl.create(:add_profile, :add_profile_173)   # 173

      # Tree
      FactoryGirl.create(:tree, :add_tree9_1)   # 86
      FactoryGirl.create(:tree, :add_tree9_2)   # 87
      FactoryGirl.create(:tree, :add_tree9_3) # before # 88
      # FactoryGirl.create(:tree, :add_tree9_4) # before # 89
      # FactoryGirl.create(:tree, :add_tree9_5) # before # 90
      FactoryGirl.create(:tree, :add_tree9_6) # before # 91
      FactoryGirl.create(:tree, :add_tree9_7)   # 92
      FactoryGirl.create(:tree, :add_tree9_172)   # 172
      FactoryGirl.create(:tree, :add_tree9_173)   # 173

      #Profile_Key
      # Before Add new Profile  -  tree #9 Petr
      FactoryGirl.create(:profile_key, :profile_key9_add_1)   # 85 86
      FactoryGirl.create(:profile_key, :profile_key9_add_2)   # 86 85
      FactoryGirl.create(:profile_key, :profile_key9_add_3)    # 85 87
      FactoryGirl.create(:profile_key, :profile_key9_add_4)   # 87 85
      FactoryGirl.create(:profile_key, :profile_key9_add_5)   # 86, 87
      FactoryGirl.create(:profile_key, :profile_key9_add_6)   # 86, 87
      FactoryGirl.create(:profile_key, :profile_key9_add_7) # before # 85 88
      FactoryGirl.create(:profile_key, :profile_key9_add_8) # before # 85 88
      FactoryGirl.create(:profile_key, :profile_key9_add_9)  # 86 88
      FactoryGirl.create(:profile_key, :profile_key9_add_10)  # 88 86
      FactoryGirl.create(:profile_key, :profile_key9_add_11)   # 87 88
      FactoryGirl.create(:profile_key, :profile_key9_add_12)   # 88 87
      # FactoryGirl.create(:profile_key, :profile_key9_add_13) # before # 85 89
      # FactoryGirl.create(:profile_key, :profile_key9_add_14) # before # 85 89
      # FactoryGirl.create(:profile_key, :profile_key9_add_15)    # 86 89
      # FactoryGirl.create(:profile_key, :profile_key9_add_16)    # 89 86
      # FactoryGirl.create(:profile_key, :profile_key9_add_17)   # 87 89
      # FactoryGirl.create(:profile_key, :profile_key9_add_18)  # 87 89
      # FactoryGirl.create(:profile_key, :profile_key9_add_19) # before # 88 89
      # FactoryGirl.create(:profile_key, :profile_key9_add_20) # before # 88 89
      # FactoryGirl.create(:profile_key, :profile_key9_add_21) # before # 85 90
      # FactoryGirl.create(:profile_key, :profile_key9_add_22) # before # 85 90
      # FactoryGirl.create(:profile_key, :profile_key9_add_23)  # 86 90
      # FactoryGirl.create(:profile_key, :profile_key9_add_24)    # 90 86
      # FactoryGirl.create(:profile_key, :profile_key9_add_25)    # 87 90
      # FactoryGirl.create(:profile_key, :profile_key9_add_26)  # 90 87
      # FactoryGirl.create(:profile_key, :profile_key9_add_27) # before  # 88 90
      # FactoryGirl.create(:profile_key, :profile_key9_add_28) # before  # 90 88
      # FactoryGirl.create(:profile_key, :profile_key9_add_29) # before  # 89 90
      # FactoryGirl.create(:profile_key, :profile_key9_add_30) # before  # 89 90
      FactoryGirl.create(:profile_key, :profile_key9_add_31) # before  # 85 91
      FactoryGirl.create(:profile_key, :profile_key9_add_32) # before  # 91 85
      # FactoryGirl.create(:profile_key, :profile_key9_add_33) # before  # 90 91
      # FactoryGirl.create(:profile_key, :profile_key9_add_34) # before  # 91 90
      FactoryGirl.create(:profile_key, :profile_key9_add_35)   # 86 91
      FactoryGirl.create(:profile_key, :profile_key9_add_36)    # 91 86
      FactoryGirl.create(:profile_key, :profile_key9_add_37)    # 87 91
      FactoryGirl.create(:profile_key, :profile_key9_add_38)    # 91 87
      FactoryGirl.create(:profile_key, :profile_key9_add_39) # before # 88 91
      FactoryGirl.create(:profile_key, :profile_key9_add_40) # before # 91 88
      # FactoryGirl.create(:profile_key, :profile_key9_add_41) # before # 89 91
      # FactoryGirl.create(:profile_key, :profile_key9_add_42) # before # 91 89
      FactoryGirl.create(:profile_key, :profile_key9_add_43)    # 85 92
      FactoryGirl.create(:profile_key, :profile_key9_add_44)   # 92 85
      # FactoryGirl.create(:profile_key, :profile_key9_add_45)   # 90 92
      # FactoryGirl.create(:profile_key, :profile_key9_add_46)   # 92 90
      FactoryGirl.create(:profile_key, :profile_key9_add_47)   # 91 92
      FactoryGirl.create(:profile_key, :profile_key9_add_48)   # 92 91
      FactoryGirl.create(:profile_key, :profile_key9_add_49)   # 92 86
      FactoryGirl.create(:profile_key, :profile_key9_add_50)   # 92 86
      FactoryGirl.create(:profile_key, :profile_key9_add_51)   # 92 87
      FactoryGirl.create(:profile_key, :profile_key9_add_52)   # 92 87

      FactoryGirl.create(:profile_key, :profile_key9_86_172_53)    # 86_172
      FactoryGirl.create(:profile_key, :profile_key9_172_86_54)    # 172_86
      FactoryGirl.create(:profile_key, :profile_key9_88_172_55)    # 88_172

      FactoryGirl.create(:profile_key, :profile_key9_172_88_56)    # 172_88
      FactoryGirl.create(:profile_key, :profile_key9_85_172_57)    # 85_172
      FactoryGirl.create(:profile_key, :profile_key9_172_85_58)    # 172_85

      FactoryGirl.create(:profile_key, :profile_key9_87_172_59)    # 87_172
      FactoryGirl.create(:profile_key, :profile_key9_172_87_60)    # 172_87
      FactoryGirl.create(:profile_key, :profile_key9_86_173_61)    # 86_173

      FactoryGirl.create(:profile_key, :profile_key9_173_86_62)    # 173 86
      FactoryGirl.create(:profile_key, :profile_key9_172_173_63)   # 172 173
      FactoryGirl.create(:profile_key, :profile_key9_173_172_64)   # 173_172

      FactoryGirl.create(:profile_key, :profile_key9_88_173_65)    # 88_173
      FactoryGirl.create(:profile_key, :profile_key9_173_88_66)   # 173_88
      FactoryGirl.create(:profile_key, :profile_key9_85_173_67)   # 85_173

      FactoryGirl.create(:profile_key, :profile_key9_173_85_68)    # 173_85
      FactoryGirl.create(:profile_key, :profile_key9_87_173_69)   # 87_173
      FactoryGirl.create(:profile_key, :profile_key9_173_87_70)   # 173_87

      # puts "before All: ProfileKey.last.user_id = #{ProfileKey.last.user_id} \n"  # user_id = 1
      # puts "before All: ProfileKey.last.name_id = #{ProfileKey.last.is_name_id} \n"  # name_id = 187
      # puts "before All: ProfileKey.count = #{ProfileKey.all.count} \n" # 112

      FactoryGirl.create(:common_log, :log_delete_profile_89)    #
      FactoryGirl.create(:common_log, :log_delete_profile_90)    #
      FactoryGirl.create(:common_log, :log_add_profile_172)    #
      FactoryGirl.create(:common_log, :log_add_profile_173)    #

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
      CommonLog.delete_all
      CommonLog.reset_pk_sequence
    }

    # create parameters
    let(:current_user_9) { create(:user, :user_9) }  # User = 9. Tree = 9. profile_id = 85
    let(:currentuser_id) {current_user_9.id}  # id = 9
    let(:connected_users) { current_user_9.get_connected_users }  # [9]

    context '- before actions - check connected_users' do
      it "- Return proper connected_users Array result for current_user_id = 9" do
        puts "Check CommonLog Model methods \n"
        puts "Before All - connected_users created \n"  #
        expect(connected_users).to be_a_kind_of(Array)
      end
      it "- Return proper connected_users Array result for current_user_id = 1" do
        puts "Let created: connected_users = #{connected_users} \n"   # [9]
        expect(connected_users).to eq([9])
      end
    end
    context '- before actions - check tables values ' do
      it '- check Tree have rows count before - Ok' do
        puts "Before All - Check tables created \n"  #
        trees_count =  Tree.all.count
        # puts "before action: trees_count = #{trees_count.inspect} \n"
        expect(trees_count).to eq(7) # got 7 rows of Tree
      end
      it '- check ProfileKey have rows count before - Ok' do
        profile_keys_count =  ProfileKey.all.count
        # puts "before action: trees_count = #{trees_count.inspect} \n"
        expect(profile_keys_count).to eq(46) # got 46 rows of ProfileKey
      end
      it '- check CommonLog have rows count before - Ok' do
        common_logs_count =  CommonLog.all.count
        # puts "before action: trees_count = #{trees_count.inspect} \n"
        expect(common_logs_count).to eq(4) # got 4 rows of CommonLog
      end
      it '- check CommonLog 1st row before - Ok' do
        common_log_first =  CommonLog.first
        # puts "before action: trees_count = #{trees_count.inspect} \n"
        expect(common_log_first.profile_id).to eq(89) # got 4 rows of CommonLog
        expect(common_log_first.id).to eq(1) # got 4 rows of CommonLog
      end
      it '- check CommonLog 2nd row before - Ok' do
        common_log_second =  CommonLog.second
        # puts "before action: trees_count = #{trees_count.inspect} \n"
        expect(common_log_second.profile_id).to eq(90) # got 4 rows of CommonLog
        expect(common_log_second.id).to eq(2) # got 4 rows of CommonLog
      end
      it '- check CommonLog 3rd row before - Ok' do
        common_log_third =  CommonLog.third
        # puts "before action: trees_count = #{trees_count.inspect} \n"
        expect(common_log_third.profile_id).to eq(172) # got 4 rows of CommonLog
        expect(common_log_third.id).to eq(3) # got 4 rows of CommonLog
      end
      it '- check CommonLog 4th row before - Ok' do
        common_log_forth =  CommonLog.find(4)
        # puts "before action: trees_count = #{trees_count.inspect} \n"
        expect(common_log_forth.profile_id).to eq(173) # got 4 rows of CommonLog
        expect(common_log_forth.id).to eq(4) # got 4 rows of CommonLog
      end

    end

    # from common_logs_controller.rb#rollback_logs#rollback_add_profile#rollback_add_one_profile
    describe ' Check action <rollback_add_one_profile>  log_id >= 3:', focus: true do

      let(:add_log_data) { {:current_user => current_user_9, :log_type => 1,
                                           :profile_id => 173 } }
      before { CommonLog.rollback_add_one_profile(add_log_data ) }
      it '- check CommonLog }2nd row before - Ok' do
        # puts "Check action <rollback_add_one_profile> : yes = #{yes.inspect} \n"
        common_logs_count =  CommonLog.all.count
        puts "Check action <rollback_add_one_profile> : common_logs_count = #{common_logs_count.inspect} \n"
        expect(common_logs_count).to eq(3) # got 4 rows of CommonLog
      end
      it '- check CommonLog 1st row before - Ok' do
        common_log_first =  CommonLog.first
        # puts "before action: trees_count = #{trees_count.inspect} \n"
        expect(common_log_first.profile_id).to eq(89) # got 4 rows of CommonLog
        expect(common_log_first.id).to eq(1) # got 4 rows of CommonLog
      end
      it '- check CommonLog 2nd row before - Ok' do
        common_log_second =  CommonLog.second
        # puts "before action: trees_count = #{trees_count.inspect} \n"
        expect(common_log_second.profile_id).to eq(90) # got 4 rows of CommonLog
        expect(common_log_second.id).to eq(2) # got 4 rows of CommonLog
      end
      it '- check CommonLog 3rd row before - Ok' do
        common_log_third =  CommonLog.third
        # puts "before action: trees_count = #{trees_count.inspect} \n"
        expect(common_log_third.profile_id).to eq(172) # got 4 rows of CommonLog
        expect(common_log_third.id).to eq(3) # got 4 rows of CommonLog
      end



    end


  end

end
