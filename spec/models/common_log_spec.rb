require 'rails_helper'

RSpec.describe CommonLog, type: :model  do # , focus: true

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
      FactoryGirl.create(:tree, :add_tree9_173)   # 173 # - add_log 173

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
      FactoryGirl.create(:profile_key, :profile_key9_86_173_61)    # 86_173 # - add_log 173
      FactoryGirl.create(:profile_key, :profile_key9_173_86_62)    # 173 86 # - add_log 173
      FactoryGirl.create(:profile_key, :profile_key9_172_173_63)   # 172 173 # - add_log 173
      FactoryGirl.create(:profile_key, :profile_key9_173_172_64)   # 173_172 # - add_log 173
      FactoryGirl.create(:profile_key, :profile_key9_88_173_65)    # 88_173 # - add_log 173
      FactoryGirl.create(:profile_key, :profile_key9_173_88_66)   # 173_88 # - add_log 173
      FactoryGirl.create(:profile_key, :profile_key9_85_173_67)   # 85_173 # - add_log 173
      FactoryGirl.create(:profile_key, :profile_key9_173_85_68)    # 173_85 # - add_log 173
      FactoryGirl.create(:profile_key, :profile_key9_87_173_69)   # 87_173 # - add_log 173
      FactoryGirl.create(:profile_key, :profile_key9_173_87_70)   # 173_87 # - add_log 173

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

    # create User parameters
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
      describe '- check Tree have rows count before - Ok' do
        let(:rows_qty) {7}
        it_behaves_like :successful_tree_rows_count
      end
      describe '- check ProfileKey have rows count before - Ok' do
        let(:rows_qty) {46}
        it_behaves_like :successful_profile_keys_rows_count
      end
      describe '- check CommonLog have rows count before - Ok' do
        let(:rows_qty) {4}
        it_behaves_like :successful_common_logs_rows_count
      end
      it '- check CommonLog 1st row before - Ok' do
        common_log_first =  CommonLog.first
        # puts "before action: trees_count = #{trees_count.inspect} \n"
        expect(common_log_first.profile_id).to eq(89)
        expect(common_log_first.id).to eq(1)
      end
      it '- check CommonLog 2nd row before - Ok' do
        common_log_second =  CommonLog.second
        # puts "before action: trees_count = #{trees_count.inspect} \n"
        expect(common_log_second.profile_id).to eq(90)
        expect(common_log_second.id).to eq(2)
      end
      it '- check CommonLog 3rd row before - Ok' do
        common_log_third =  CommonLog.third
        # puts "before action: trees_count = #{trees_count.inspect} \n"
        expect(common_log_third.profile_id).to eq(172)
        expect(common_log_third.id).to eq(3)
      end
      it '- check CommonLog 4th row before - Ok' do
        common_log_forth =  CommonLog.find(4)
        # puts "before action: trees_count = #{trees_count.inspect} \n"
        expect(common_log_forth.profile_id).to eq(173)
        expect(common_log_forth.id).to eq(4)
      end
      describe '- check all relations generated in ProfileKey rows: start state - Ok'  do  # , focus: true
        let(:relations_ids_arr) {[1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 5, 5, 7, 7, 7, 8, 8, 8, 13, 13, 14,
                                  14, 17, 17, 17, 17, 91, 91, 91, 101, 101, 101, 111, 111, 111, 111, 121, 121,
                                  191, 221]}
        let(:relations_arr_size) {46}
        it_behaves_like :successful_profile_keys_relation_ids
      end
      describe '- check all profile_ids generated in ProfileKey rows: start state - Ok' do
        let(:profiles_ids_arr) {[85, 85, 85, 85, 85, 85, 85, 86, 86, 86, 86, 86, 86, 86, 87, 87, 87, 87, 87, 87, 87,
                                 88, 88, 88, 88, 88, 88, 91, 91, 91, 91, 91, 92, 92, 92, 92, 172, 172, 172, 172, 172,
                                 173, 173, 173, 173, 173]}
        let(:profiles_ids_arr_size) {46}
        it_behaves_like :successful_profile_keys_profile_ids
      end

    end

    # from common_logs_controller.rb#rollback_logs#rollback_add_profile#rollback_add_one_profile , focus: true
    describe ' Check action <rollback_add_one_profile> :' do
      context '- rollback add profile = 173 - check tables values ' do

        let(:add_log_data) { {:current_user => current_user_9, :log_type => 1, :profile_id => 173, common_log_id: 4 } }
        before { CommonLog.rollback_add_one_profile(add_log_data ) }

        describe '- check CommonLog have rows count - Ok' do
          let(:rows_qty) {3}
          it_behaves_like :successful_common_logs_rows_count
        end
        it '- check CommonLog 1st row - Ok' do
          common_log_first =  CommonLog.first
          puts "Check CommonLog.rollback_add_one_profile: -173 \n"
          # puts "before action: trees_count = #{trees_count.inspect} \n"
          expect(common_log_first.profile_id).to eq(89)
          expect(common_log_first.id).to eq(1)
        end
        it '- check CommonLog 2nd row - Ok' do
          common_log_second =  CommonLog.second
          # puts "before action: trees_count = #{trees_count.inspect} \n"
          expect(common_log_second.profile_id).to eq(90)
          expect(common_log_second.id).to eq(2)
        end
        it '- check CommonLog 3rd row - Ok' do
          common_log_third =  CommonLog.third
          # puts "before action: trees_count = #{trees_count.inspect} \n"
          expect(common_log_third.profile_id).to eq(172)
          expect(common_log_third.id).to eq(3)
        end
        describe '- check Tree have rows count - Ok' do
          let(:rows_qty) {6}
          it_behaves_like :successful_tree_rows_count
        end
        describe '- check ProfileKey have rows count - Ok' do
          let(:rows_qty) {36}
          it_behaves_like :successful_profile_keys_rows_count
        end
        describe '- check all relations generated in ProfileKey rows - Ok' do  # , focus: true
          let(:relations_ids_arr) {[1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 5, 5, 7, 7, 8, 8, 13, 13, 14, 17, 17, 17,
                                    91, 91, 91, 101, 111, 111, 121, 121, 191, 221]}
          let(:relations_arr_size) {36}
          it_behaves_like :successful_profile_keys_relation_ids
        end
        describe '- check all profile_ids generated in ProfileKey rows - Ok' do
          let(:profiles_ids_arr) {[85, 85, 85, 85, 85, 85, 86, 86, 86, 86, 86, 86, 87, 87, 87, 87, 87, 87, 88, 88, 88,
                                   88, 88, 91, 91, 91, 91, 91, 92, 92, 92, 92, 172, 172, 172, 172]}
          let(:profiles_ids_arr_size) {36}
          it_behaves_like :successful_profile_keys_profile_ids
        end
      end

      context '- rollback add profile = 172 - check tables values ' do

        let(:add_log_data) { {:current_user => current_user_9, :log_type => 1, :profile_id => 172, common_log_id: 3 } }
        before { CommonLog.rollback_add_one_profile(add_log_data ) }

        describe '- check CommonLog have rows count - Ok' do
          let(:rows_qty) {3}
          it_behaves_like :successful_common_logs_rows_count
        end
        it '- check CommonLog 1st row - Ok' do
          common_log_first =  CommonLog.first
          puts "Check CommonLog.rollback_add_one_profile: -172 \n"
          # puts "before action: trees_count = #{trees_count.inspect} \n"
          expect(common_log_first.profile_id).to eq(89) # got profile_id
          expect(common_log_first.id).to eq(1) # got id rows of CommonLog
        end
        it '- check CommonLog 2nd row - Ok' do
          common_log_second =  CommonLog.second
          # puts "before action: trees_count = #{trees_count.inspect} \n"
          expect(common_log_second.profile_id).to eq(90)
          expect(common_log_second.id).to eq(2)
        end
        it '- check CommonLog 3rd row - Ok' do
          common_log_third =  CommonLog.third
          # puts "before action: trees_count = #{trees_count.inspect} \n"
          expect(common_log_third.profile_id).to eq(173)
          expect(common_log_third.id).to eq(4)
        end
        describe '- check Tree have rows count - Ok' do
          let(:rows_qty) {6}
          it_behaves_like :successful_tree_rows_count
        end
        describe '- check ProfileKey have rows count - Ok' do
          let(:rows_qty) {36}
          it_behaves_like :successful_profile_keys_rows_count
        end
        describe '- check all relations generated in ProfileKey rows - Ok'  do  # , focus: true
          let(:relations_ids_arr) {[1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 5, 5, 7, 7, 8, 8, 13, 14, 14, 17, 17, 17,
                                    91, 101, 101, 101, 111, 111, 121, 121, 191, 221]}
          let(:relations_arr_size) {36}
          it_behaves_like :successful_profile_keys_relation_ids
        end
        describe '- check all profile_ids generated in ProfileKey rows - Ok' do
          let(:profiles_ids_arr) {[85, 85, 85, 85, 85, 85, 86, 86, 86, 86, 86, 86, 87, 87, 87, 87, 87, 87, 88, 88, 88,
                                   88, 88, 91, 91, 91, 91, 91, 92, 92, 92, 92, 173, 173, 173, 173]}
          let(:profiles_ids_arr_size) {36}
          it_behaves_like :successful_profile_keys_profile_ids
        end
      end

    end

    describe ' Check action <rollback_destroy_one_profile> :' do
      context '- rollback destroy profile = 90 - check tables values ' do

        let(:destroy_log_data) { {:current_user => current_user_9, :log_type => 2, :profile_id => 90,
                                  :base_profile_id => 85, :relation_id => 3, common_log_id: 2    } }
        before { CommonLog.rollback_destroy_one_profile(destroy_log_data) }

        describe '- check CommonLog have rows count: 4 - 1 = 3 - Ok' do
          let(:rows_qty) {3}
          it_behaves_like :successful_common_logs_rows_count
        end
        it '- check CommonLog 1st row - Ok' do
          common_log_first =  CommonLog.first
          puts "Check CommonLog.rollback_destroy_one_profile: +90 \n"
          # puts "before action: trees_count = #{trees_count.inspect} \n"
          expect(common_log_first.profile_id).to eq(89)
          expect(common_log_first.id).to eq(1)
        end
        it '- check CommonLog 2nd row - Ok' do
          common_log_second =  CommonLog.second
          # puts "before action: trees_count = #{trees_count.inspect} \n"
          expect(common_log_second.profile_id).to eq(172)
          expect(common_log_second.id).to eq(3)
        end
        it '- check CommonLog 3rd row - Ok' do
          common_log_third =  CommonLog.third
          # puts "before action: trees_count = #{trees_count.inspect} \n"
          expect(common_log_third.profile_id).to eq(173)
          expect(common_log_third.id).to eq(4)
        end
        describe '- check Tree have rows count: + 90 profile - Ok' do
          let(:rows_qty) {8}
          it_behaves_like :successful_tree_rows_count
        end
        describe '- check ProfileKey have rows count: + 90 profile - Ok' do
          let(:rows_qty) {58}
          it_behaves_like :successful_profile_keys_rows_count
        end
        describe '- check all relations generated in ProfileKey rows - Ok' do  # , focus: true
          let(:relations_ids_arr) {[1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 5, 5, 5, 6, 7, 7, 7, 8,
                                    8, 8, 13, 13, 14, 14, 17, 17, 17, 17, 91, 91, 91, 91, 101, 101, 101, 101, 111, 111,
                                    111, 111, 111, 111, 121, 121, 191, 191, 211, 221]}
          let(:relations_arr_size) {58}
          it_behaves_like :successful_profile_keys_relation_ids
        end
        describe '- check all profile_ids generated in ProfileKey rows - Ok' do
          let(:profiles_ids_arr) {[85, 85, 85, 85, 85, 85, 85, 85, 86, 86, 86, 86, 86, 86, 86, 86, 87, 87, 87, 87, 87,
                                   87, 87, 87, 88, 88, 88, 88, 88, 88, 88, 90, 90, 90, 90, 90, 90, 91, 91, 91, 91, 91,
                                   91, 92, 92, 92, 92, 92, 172, 172, 172, 172, 172, 173, 173, 173, 173, 173]}
          let(:profiles_ids_arr_size) {58}
          it_behaves_like :successful_profile_keys_profile_ids
        end
      end

      context '- rollback destroy profile = 89 - check tables values ' do  # , focus: true

        let(:destroy_log_data) { {:current_user => current_user_9, :log_type => 2, :profile_id => 89,
                                  :base_profile_id => 85, :relation_id => 6, common_log_id: 1 } }
        before { CommonLog.rollback_destroy_one_profile(destroy_log_data) }

        describe '- check CommonLog have rows count: 4 - 1 = 3 - Ok' do
          let(:rows_qty) {3}
          it_behaves_like :successful_common_logs_rows_count
        end
        it '- check CommonLog 1st row - Ok' do
          common_log_first =  CommonLog.first
          puts "Check CommonLog.rollback_destroy_one_profile: +89 \n"
          expect(common_log_first.profile_id).to eq(90) # got profile_id
          expect(common_log_first.id).to eq(2) # got id rows of CommonLog
        end
        it '- check CommonLog 2nd row - Ok' do
          common_log_second =  CommonLog.second
          # puts "before action: trees_count = #{trees_count.inspect} \n"
          expect(common_log_second.profile_id).to eq(172)
          expect(common_log_second.id).to eq(3)
        end
        it '- check CommonLog 3rd row - Ok' do
          common_log_third =  CommonLog.third
          # puts "before action: trees_count = #{trees_count.inspect} \n"
          expect(common_log_third.profile_id).to eq(173)
          expect(common_log_third.id).to eq(4)
        end
        describe '- check Tree have rows count: + 89 profile - Ok' do
          let(:rows_qty) {8}
          it_behaves_like :successful_tree_rows_count
        end
        describe '- check ProfileKey have rows count: + 89 profile - Ok' do
          let(:rows_qty) {56}
          it_behaves_like :successful_profile_keys_rows_count
        end
        describe '- check all relations generated in ProfileKey rows - Ok'  do  # , focus: true
          let(:relations_ids_arr) {[1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 7, 7,
                                    7, 8, 8, 8, 13, 13, 14, 14, 17, 17, 17, 17, 91, 91, 91, 101, 101, 101, 111, 111,
                                    111, 111, 121, 121, 191, 201, 221, 221]}
          let(:relations_arr_size) {56}
          it_behaves_like :successful_profile_keys_relation_ids
        end
        describe '- check all profile_ids generated in ProfileKey rows - Ok' do
          let(:profiles_ids_arr) {[85, 85, 85, 85, 85, 85, 85, 85, 86, 86, 86, 86, 86, 86, 86, 86, 87, 87, 87, 87, 87,
                                   87, 87, 87, 88, 88, 88, 88, 88, 88, 88, 89, 89, 89, 89, 89, 91, 91, 91, 91, 91, 91,
                                   92, 92, 92, 92, 172, 172, 172, 172, 172, 173, 173, 173, 173, 173]}
          let(:profiles_ids_arr_size) {56}
          it_behaves_like :successful_profile_keys_profile_ids
        end
      end

    end

    describe ' Check action <rollback_similars_profiles(common_log_id)> :', disable: true do
        # todo: Чтобы тестить разъединение похожих нужно:
        #       отредактировать facories tables до состояния similars connected
        #     удалить неконнектед ряды и добавить коннектед
        #   звпускать метод модели Common_log rollback_similars_profiles
        # ожидать корректные Common_logs = 0  UpdateFeeds = 2 ...
        let(:current_user) { create(:user) }   # User = 1. Tree = 1. profile_id = 63
        let(:currentuser_id) {current_user.id}
        let(:disconnect_sims_common_log_id) {1}

        before {
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
          WeafamSetting.delete_all
          WeafamSetting.reset_pk_sequence
          Name.delete_all
          Name.reset_pk_sequence
          SimilarsFound.delete_all
          SimilarsFound.reset_pk_sequence
          CommonLog.delete_all
          CommonLog.reset_pk_sequence
          UpdatesFeed.delete_all
          UpdatesFeed.reset_pk_sequence

          # allow(controller).to receive(:logged_in?)
          # allow(controller).to receive(:current_user).and_return current_user
          # puts "1 before All: currentuser_id = #{currentuser_id} \n" # currentuser_id = 1
          # puts "before All: current_user.profile_id = #{current_user.profile_id} \n"

          #Name
          FactoryGirl.create(:name, :name_40)
          FactoryGirl.create(:name, :name_173)
          FactoryGirl.create(:name, :name_351)
          FactoryGirl.create(:name, :name_354)
          FactoryGirl.create(:name, :name_370)
          FactoryGirl.create(:name, :name_422)
          # puts "before All: Name.first.name = #{Name.first.name} \n"  # Андрей

          FactoryGirl.create(:user, :user_2)  # User = 2. Tree = 2. profile_id = 66
          FactoryGirl.create(:user, :user_3)  # User = 3. Tree = 3. profile_id = 333
          FactoryGirl.create(:user, :user_4)  # User = 4. Tree = 4. profile_id = 444
          # puts "before All: User.last.id = #{User.last.id} \n" # id = 2
          # puts "before All: User.find(2).profile_id = #{User.find(2).profile_id} \n" # id = 2
          # puts "before All: user_2.profile_id = #{user_2.profile_id} \n" # id = 2   profile_id = 66

          FactoryGirl.create(:connected_user, :correct)      # 1  2
          # FactoryGirl.create(:connected_user, :correct_3_4)  # 3  4
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
          # puts "before All: Profile.find(63).user_id = #{Profile.find(63).user_id.inspect} \n"  # id = 63
          # puts "before All: Profile.find(63).name_id = #{Profile.find(63).name_id.inspect} \n"  # id = 63
          # puts "before All: Profile.find(66).user_id = #{Profile.find(66).user_id.inspect} \n"  # id = 66
          # puts "before All: Profile.find(84).user_id = #{Profile.find(84).user_id.inspect} \n"  # id = 63
          # puts "before All: Profile.find(66).name_id = #{Profile.find(66).name_id.inspect} \n"  # id = 66
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

          #Weafam_Settings
          FactoryGirl.create(:weafam_setting)
          # puts "before All: WeafamSetting.first.certain_koeff = #{WeafamSetting.first.certain_koeff} \n"  # 4


         get :internal_similars_search
         get :connect_similars,
            first_profile_id: first_init_profile, second_profile_id: second_init_profile,
            :format => 'js'


         # CommonLog.rollback_destroy_one_profile(disconnect_sims_common_log_id)

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
        WeafamSetting.delete_all
        WeafamSetting.reset_pk_sequence
        Name.delete_all
        Name.reset_pk_sequence
        SimilarsFound.delete_all
        SimilarsFound.reset_pk_sequence
        CommonLog.delete_all
        CommonLog.reset_pk_sequence
        UpdatesFeed.delete_all
        UpdatesFeed.reset_pk_sequence
      }

      context ' - check CommonLog table After <connect_similars>' do  # , focus: true
        # describe '- check CommonLog have rows count - Ok ' do
        #   # puts "In check CommonLog in SimilarsLog:  connected_at = #{connected_at.inspect} \n"
        #   let(:rows_qty) {0}
        #   it_behaves_like :successful_common_logs_rows_count
        # end
        # it '- check CommonLog 1st & last row - Ok' do # , focus: true
        #   common_log_row_fields = CommonLog.last.attributes.except('created_at','updated_at')
        #   expect(common_log_row_fields).to eq({"id"=>1, "user_id"=>1, "log_type"=>3, "log_id"=>1, "profile_id"=>63,
        #                                        "base_profile_id"=>63, "relation_id"=>888} )
        # end
      end


       # context '- check UpdatesFeed After <disconnect_similars>' , focus: true  do #, focus: true
       #    describe '- check UpdatesFeed rows count After <disconnect_similars>' do
       #      let(:rows_qty) {2}  #
       #      it_behaves_like :successful_updates_feed_rows_count
       #    end
       #    describe '- check UpdatesFeed ids_arr After <disconnect_similars>' do
       #      let(:ids_arr) {2}  #
       #      it_behaves_like :successful_updates_feed_ids
       #    end


          # it '- check UpdatesFeed 1 row - Ok'  do #
          #   connection_request_fields = UpdatesFeed.first.attributes.except('created_at','updated_at')
          #   expect(connection_request_fields).to eq({"id"=>1, "user_id"=>1, "update_id"=>19, "agent_user_id"=>1,
          #                                            "read"=>false, "agent_profile_id"=>63, "who_made_event"=>1} )
          # end
        # end



    end

  end

end
