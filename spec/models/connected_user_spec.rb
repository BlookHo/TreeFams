require 'rails_helper'

RSpec.describe ConnectedUser, :type => :model do

  describe '- Validation' do
    describe '- on create' do

      context '- valid connected_users' do
        let(:good_connected_users) {FactoryGirl.build(:connected_user, :correct)}
        it '- 1. Saves a valid good_connected_users pair' do
          puts " Model ConnectedUser validation "
          expect(good_connected_users).to be_valid
        end
        let(:good_connected_users_2) {FactoryGirl.build(:connected_user, :big_IDs)}
        it '- 2. Saves a valid connected_users pair - big IDs' do
          expect(good_connected_users_2).to be_valid
        end
      end

      context '- Invalid connected_users pairs' do
        let(:bad_connected_users_1) {FactoryGirl.build(:connected_user, :user_id_nil)}
        it '- 1. Does not save an invalid connected_users pair - user_id_nil' do
          expect(bad_connected_users_1).to_not be_valid
        end
        let(:bad_connected_users_2) {FactoryGirl.build(:connected_user, :ids_equal)}
        it '- 2. Does not save an invalid connected_users pair - equal Profile_IDs' do
          expect(bad_connected_users_2).to_not be_valid
        end
        let(:bad_connected_users_3) {FactoryGirl.build(:connected_user, :one_id_less_zero)}
        it '- 3. Does not save an invalid connected_users pair - one_id_less_zero' do
          expect(bad_connected_users_3).to_not be_valid
        end
        let(:bad_connected_users_4) {FactoryGirl.build(:connected_user, :other_id_less_zero)}
        it '- 4. Does not save an invalid connected_users pair - other_id_less_zero' do
          expect(bad_connected_users_4).to_not be_valid
        end
        let(:bad_connected_users_5) {FactoryGirl.build(:connected_user, :one_id_Uninteger)}
        it '- 5. Does not save an invalid connected_users pair - one_id_Uninteger' do
          expect(bad_connected_users_5).to_not be_valid
        end
      end

      context '- invalid connected_users rows' do
        let(:bad_profiles_fields_are_equal) {FactoryGirl.build(:connected_user, :bad_profiles_fields_eual)}
        it '- 1 Dont save: - bad_profiles_fields - equal' do
          expect(bad_profiles_fields_are_equal).to_not be_valid
        end
      end
    end
  end

  describe '- CHECK ConnectedUser Model methods' do

    # create model data
    before {
      #Name -  # before
      FactoryGirl.create(:name, :name_28)    # Алексей
      FactoryGirl.create(:name, :name_48)    # Анна
      FactoryGirl.create(:name, :name_82)    # Валентина
      FactoryGirl.create(:name, :name_90)    # Василий
      FactoryGirl.create(:name, :name_97)    # Вера
      FactoryGirl.create(:name, :name_110)   # Владимир
      FactoryGirl.create(:name, :name_122)   # Вячеслав
      FactoryGirl.create(:name, :name_147)   # Дарья
      FactoryGirl.create(:name, :name_194)   # Иван
      FactoryGirl.create(:name, :name_249)   # Ксения
      FactoryGirl.create(:name, :name_293)   # Мария
      FactoryGirl.create(:name, :name_331)   # Наталья
      FactoryGirl.create(:name, :name_343)   # Николай
      FactoryGirl.create(:name, :name_345)   # Нина
      FactoryGirl.create(:name, :name_361)   # Павел
      FactoryGirl.create(:name, :name_370)   # Петр
      FactoryGirl.create(:name, :name_412)   # Светлана
      FactoryGirl.create(:name, :name_419)   # Семен
      FactoryGirl.create(:name, :name_446)   # Таисия
      FactoryGirl.create(:name, :name_449)   # Татьяна
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

      # User current_user_1_connected
      FactoryGirl.create(:user, :current_user_1_connected )  # User = 1 . Tree = [1,2]. profile_id = 17
      FactoryGirl.create(:user, :user_2_connected )  # User = 2 . Tree = [1,2]. profile_id = 11
          # puts "before All: User.last.id = #{User.last.id}, .profile_id = #{User.last.profile_id} \n"  # user_id = 1
      FactoryGirl.create(:user, :user_3_to_connect )  # User = 3 . Tree = [3]. profile_id = 22
      # puts "before All: User.second.id = #{User.second.id}, .profile_id = #{User.second.profile_id} \n"  # user_id = 1
      FactoryGirl.create(:user, :user_4 )  # User = 4 . Tree = 10. profile_id = 444
      FactoryGirl.create(:user, :user_5 )  # User = 5 . Tree = 10. profile_id = 555
      FactoryGirl.create(:user, :user_6 )  # User = 6 . Tree = 10. profile_id = 666
      FactoryGirl.create(:user, :user_7 )  # User = 7. Tree = 10. profile_id = 777
      FactoryGirl.create(:user, :user_8 )  # User = 8 . Tree = 10. profile_id = 888

      # ConnectedUser
      FactoryGirl.create(:connected_user, :correct)      # 1  2
      FactoryGirl.create(:connected_user, :correct_7_8)  # 7  8

      # Profile
      FactoryGirl.create(:connect_profile)   # 1
      FactoryGirl.create(:connect_profile, :connect_profile_2)   # 2
      FactoryGirl.create(:connect_profile, :connect_profile_3)   # 3
      FactoryGirl.create(:connect_profile, :connect_profile_7)   # 7
      FactoryGirl.create(:connect_profile, :connect_profile_8)   # 8
      FactoryGirl.create(:connect_profile, :connect_profile_9)   # 9
      FactoryGirl.create(:connect_profile, :connect_profile_10)  # 10
      # puts "before All: Profile.last.id = #{Profile.last.id}, .user_id = #{Profile.last.user_id.inspect} \n"  # user_id = nil
      # puts "before All: Profile.8.id = #{Profile.find(8).id}, .name_id = #{Profile.find(8).name_id} \n"  # name_id = 449
      FactoryGirl.create(:connect_profile, :connect_profile_11)  # 11
      FactoryGirl.create(:connect_profile, :connect_profile_12)  # 12
      FactoryGirl.create(:connect_profile, :connect_profile_13)  # 13
      FactoryGirl.create(:connect_profile, :connect_profile_14)  # 14
      FactoryGirl.create(:connect_profile, :connect_profile_15)  # 15
      FactoryGirl.create(:connect_profile, :connect_profile_16)  # 16
      FactoryGirl.create(:connect_profile, :connect_profile_17)  # 17
      FactoryGirl.create(:connect_profile, :connect_profile_18)  # 18
      FactoryGirl.create(:connect_profile, :connect_profile_19)  # 19
      FactoryGirl.create(:connect_profile, :connect_profile_20)  # 20
      FactoryGirl.create(:connect_profile, :connect_profile_21)  # 21
      FactoryGirl.create(:connect_profile, :connect_profile_22)  # 22
      FactoryGirl.create(:connect_profile, :connect_profile_23)  # 23
      FactoryGirl.create(:connect_profile, :connect_profile_24)  # 24
      FactoryGirl.create(:connect_profile, :connect_profile_25)  # 25
      FactoryGirl.create(:connect_profile, :connect_profile_26)  # 26
      FactoryGirl.create(:connect_profile, :connect_profile_27)  # 27
      FactoryGirl.create(:connect_profile, :connect_profile_28)  # 28
      FactoryGirl.create(:connect_profile, :connect_profile_29)  # 29

      # Tree
      FactoryGirl.create(:connection_trees)                        # 17 pr2
      FactoryGirl.create(:connection_trees, :connect_tree_1_pr3)   # 17 pr3
      FactoryGirl.create(:connection_trees, :connect_tree_1_pr15)  # 17 pr15
      FactoryGirl.create(:connection_trees, :connect_tree_1_pr16)  # 17 pr16
      FactoryGirl.create(:connection_trees, :connect_tree_1_pr11)  # 17 pr11
      FactoryGirl.create(:connection_trees, :connect_tree_1_pr7)   # 2  pr7
      FactoryGirl.create(:connection_trees, :connect_tree_1_pr8)   # 2  pr8
      FactoryGirl.create(:connection_trees, :connect_tree_1_pr9)   # 3  pr9
      FactoryGirl.create(:connection_trees, :connect_tree_1_pr10)  # 3  pr10

      FactoryGirl.create(:connection_trees, :connect_tree_2_pr12)  # 11 pr12
      FactoryGirl.create(:connection_trees, :connect_tree_2_pr13)  # 11 pr13
      FactoryGirl.create(:connection_trees, :connect_tree_2_pr14)  # 11 pr14
      FactoryGirl.create(:connection_trees, :connect_tree_2_pr15)  # 11 pr15
      FactoryGirl.create(:connection_trees, :connect_tree_2_pr16)  # 11 pr16
      FactoryGirl.create(:connection_trees, :connect_tree_2_pr17)  # 11 pr17
      FactoryGirl.create(:connection_trees, :connect_tree_2_pr18)  # 12 pr18
      FactoryGirl.create(:connection_trees, :connect_tree_2_pr19)  # 12 pr19
      FactoryGirl.create(:connection_trees, :connect_tree_2_pr20)  # 13 pr20
      FactoryGirl.create(:connection_trees, :connect_tree_2_pr21)  # 13 pr21

      FactoryGirl.create(:connection_trees, :connect_tree_3_pr23)  # 22 pr23
      FactoryGirl.create(:connection_trees, :connect_tree_3_pr24)  # 22 pr24
      FactoryGirl.create(:connection_trees, :connect_tree_3_pr25)  # 22 pr25
      FactoryGirl.create(:connection_trees, :connect_tree_3_pr26)  # 23 pr26
      FactoryGirl.create(:connection_trees, :connect_tree_3_pr27)  # 23 pr27
      FactoryGirl.create(:connection_trees, :connect_tree_3_pr28)  # 24 pr28
      FactoryGirl.create(:connection_trees, :connect_tree_3_pr29)  # 24 pr29

      FactoryGirl.create(:connection_trees, :connect_tree_1_pr14)  # 11 pr14

      FactoryGirl.create(:connection_trees, :connect_tree_2_pr124) # 15 pr124

      # puts "before All: Tree.last.id 12 = #{Tree.last.id}, .user_id 2 = #{Tree.last.user_id.inspect} \n"  #
      # puts "before All: Tree.last.relation_id  6 = #{Tree.last.relation_id},
      #          .profile_id 11 = #{Tree.last.profile_id.inspect}, name_id 48 = #{Tree.last.name_id.inspect},
      #          .is_profile_id 14 = #{Tree.last.is_profile_id.inspect}   \n"  #
      # puts "before All: Tree.9.id = #{Tree.find(9).id}, .name_id 82 = #{Tree.find(9).name_id} \n"  #

      #Profile_Key
      FactoryGirl.create(:connection_profile_keys)                             # 17  2
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_2)   # 2   17
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_3)   # 17  3
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_4)   # 3  17
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_5)   # 2   3
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_6)   # 3   2
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_7)   # 17 15
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_8)   # 15  17
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_9)   # 2   15
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_10)   # 15  2
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_11)   # 3   15
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_12)   # 15  3
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_13)   # 17  16
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_14)   # 16  17
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_15)   # 15  16
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_16)   # 16  15
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_17)   # 2   16
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_18)   # 16  2
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_19)   #  3  16
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_20)   # 16  3
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_21)   # 17  11
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_22)   # 11  17
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_23)   # 15  11
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_24)   # 11  15
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_25)   # 16  11
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_26)   # 11  16
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_27)   # 2   11
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_28)   # 11  2
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_29)   # 3   11
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_30)   # 11  3
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_31)   # 2   7
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_32)   # 7   2
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_33)   # 17  7
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_34)   # 7  17
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_35)   # 3   7
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_36)   # 7  3
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_37)   # 2  8
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_38)   # 8   2
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_39)   # 7  8
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_40)   # 8  7
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_41)   # 17  8
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_42)   # 8  17
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_43)   # 3  8
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_44)   # 8   3
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_45)   # 3  9
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_46)   # 9  3
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_47)   # 17  9
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_48)   # 9  17



      #     # puts "before All: ProfileKey.last.user_id = #{ProfileKey.last.user_id} \n"  # user_id = 1
  #     # puts "before All: ProfileKey.last.name_id = #{ProfileKey.last.is_name_id} \n"  # name_id = 187
  #     # puts "before All: ProfileKey.count = #{ProfileKey.all.count} \n" # 112
  #
  #     FactoryGirl.create(:common_log, :log_delete_profile_89)    #
  #     FactoryGirl.create(:common_log, :log_delete_profile_90)    #
  #     FactoryGirl.create(:common_log, :log_add_profile_172)    #
  #     FactoryGirl.create(:common_log, :log_add_profile_173)    #
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
      # CommonLog.delete_all
      # CommonLog.reset_pk_sequence
    }

    # create User parameters
    let(:current_user_1) { User.first }  # User = 1. Tree = [1,2]. profile_id = 17
    let(:currentuser_id) {current_user_1.id}  # id = 1
    let(:connected_users) { current_user_1.get_connected_users }  # [1,2]

    context '- before actions - check connected_users' do
      it "- Return proper connected_users Array result for current_user_id = 1" do
        puts "Let created: currentuser_id = #{currentuser_id} \n"   # 1
        puts "Check ConnectedUser Model methods \n"
        puts "Before All - connected_users created \n"  #
        expect(connected_users).to be_a_kind_of(Array)
      end
      it "- Return proper connected_users Array result for current_user_id = 1" do
        puts "Let created: connected_users = #{connected_users} \n"   # [1,2]
        expect(connected_users).to eq([1,2])
      end
    end
    context '- before actions - check tables values ' , focus: true do   #
      describe '- check Profile have rows count before - Ok' do
        let(:rows_qty) {26}
        it_behaves_like :successful_profiles_rows_count
      end
      describe '- check Tree have rows count before - Ok' do
        let(:rows_qty) {28}
        it_behaves_like :successful_tree_rows_count
      end
      describe '- check ProfileKey have rows count before - Ok' do
        # let(:rows_qty) {46}
        # it_behaves_like :successful_profile_keys_rows_count
      end
      describe '- check ConnectedUser have rows count before - Ok' do
        let(:rows_qty) {2}
        it_behaves_like :successful_connected_users_rows_count
      end
      # it '- check CommonLog 1st row before - Ok' do
      #   common_log_first =  CommonLog.first
      #   # puts "before action: trees_count = #{trees_count.inspect} \n"
      #   expect(common_log_first.profile_id).to eq(89)
      #   expect(common_log_first.id).to eq(1)
      # end
      # it '- check CommonLog 2nd row before - Ok' do
      #   common_log_second =  CommonLog.second
      #   # puts "before action: trees_count = #{trees_count.inspect} \n"
      #   expect(common_log_second.profile_id).to eq(90)
      #   expect(common_log_second.id).to eq(2)
      # end
      # it '- check CommonLog 3rd row before - Ok' do
      #   common_log_third =  CommonLog.third
      #   # puts "before action: trees_count = #{trees_count.inspect} \n"
      #   expect(common_log_third.profile_id).to eq(172)
      #   expect(common_log_third.id).to eq(3)
      # end
      # it '- check CommonLog 4th row before - Ok' do
      #   common_log_forth =  CommonLog.find(4)
      #   # puts "before action: trees_count = #{trees_count.inspect} \n"
      #   expect(common_log_forth.profile_id).to eq(173)
      #   expect(common_log_forth.id).to eq(4)
      # end
    end

    #   # from common_logs_controller.rb#rollback_logs#rollback_add_profile#rollback_add_one_profile , focus: true
    #   describe ' Check action <rollback_add_one_profile> :' do
    #     context '- rollback add profile = 173 - check tables values ' do
    #
    #       let(:add_log_data) { {:current_user => current_user_9, :log_type => 1, :profile_id => 173 } }
    #       before { CommonLog.rollback_add_one_profile(add_log_data ) }
    #
    #       describe '- check CommonLog have rows count - Ok' do
    #         let(:rows_qty) {3}
    #         it_behaves_like :successful_common_logs_rows_count
    #       end
    #       it '- check CommonLog 1st row - Ok' do
    #         common_log_first =  CommonLog.first
    #         # puts "before action: trees_count = #{trees_count.inspect} \n"
    #         expect(common_log_first.profile_id).to eq(89)
    #         expect(common_log_first.id).to eq(1)
    #       end
    #       it '- check CommonLog 2nd row - Ok' do
    #         common_log_second =  CommonLog.second
    #         # puts "before action: trees_count = #{trees_count.inspect} \n"
    #         expect(common_log_second.profile_id).to eq(90)
    #         expect(common_log_second.id).to eq(2)
    #       end
    #       it '- check CommonLog 3rd row - Ok' do
    #         common_log_third =  CommonLog.third
    #         # puts "before action: trees_count = #{trees_count.inspect} \n"
    #         expect(common_log_third.profile_id).to eq(172)
    #         expect(common_log_third.id).to eq(3)
    #       end
    #       describe '- check Tree have rows count - Ok' do
    #         let(:rows_qty) {6}
    #         it_behaves_like :successful_tree_rows_count
    #       end
    #       describe '- check ProfileKey have rows count - Ok' do
    #         let(:rows_qty) {36}
    #         it_behaves_like :successful_profile_keys_rows_count
    #       end
    #       describe '- check all relations generated in ProfileKey rows - Ok' do  # , focus: true
    #         let(:relations_ids_arr) {[1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 5, 5, 7, 7, 8, 8, 13, 13, 14, 17, 17, 17,
    #                                   91, 91, 91, 101, 111, 111, 121, 121, 191, 221]}
    #         let(:relations_arr_size) {36}
    #         it_behaves_like :successful_profile_keys_relation_ids
    #       end
    #       describe '- check all relations generated in ProfileKey rows - Ok'  do  # , focus: true
    #         let(:relations_ids_arr) {[1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 5, 5, 7, 7, 8, 8, 13, 13, 14, 17, 17, 17,
    #                                   91, 91, 91, 101, 111, 111, 121, 121, 191, 221]}
    #         let(:relations_arr_size) {36}
    #         it_behaves_like :successful_profile_keys_relation_ids
    #       end
    #       describe '- check all profile_ids generated in ProfileKey rows - Ok' do
    #         let(:profiles_ids_arr) {[85, 85, 85, 85, 85, 85, 86, 86, 86, 86, 86, 86, 87, 87, 87, 87, 87, 87, 88, 88, 88,
    #                                  88, 88, 91, 91, 91, 91, 91, 92, 92, 92, 92, 172, 172, 172, 172]}
    #         let(:profiles_ids_arr_size) {36}
    #         it_behaves_like :successful_profile_keys_profile_ids
    #       end
    #     end
    #
    #     context '- rollback add profile = 172 - check tables values ' do
    #
    #       let(:add_log_data) { {:current_user => current_user_9, :log_type => 1, :profile_id => 172 } }
    #       before { CommonLog.rollback_add_one_profile(add_log_data ) }
    #
    #       describe '- check CommonLog have rows count - Ok' do
    #         let(:rows_qty) {3}
    #         it_behaves_like :successful_common_logs_rows_count
    #       end
    #       it '- check CommonLog 1st row - Ok' do
    #         common_log_first =  CommonLog.first
    #         # puts "before action: trees_count = #{trees_count.inspect} \n"
    #         expect(common_log_first.profile_id).to eq(89) # got profile_id
    #         expect(common_log_first.id).to eq(1) # got id rows of CommonLog
    #       end
    #       it '- check CommonLog 2nd row - Ok' do
    #         common_log_second =  CommonLog.second
    #         # puts "before action: trees_count = #{trees_count.inspect} \n"
    #         expect(common_log_second.profile_id).to eq(90)
    #         expect(common_log_second.id).to eq(2)
    #       end
    #       it '- check CommonLog 3rd row - Ok' do
    #         common_log_third =  CommonLog.third
    #         # puts "before action: trees_count = #{trees_count.inspect} \n"
    #         expect(common_log_third.profile_id).to eq(173)
    #         expect(common_log_third.id).to eq(4)
    #       end
    #       describe '- check Tree have rows count - Ok' do
    #         let(:rows_qty) {6}
    #         it_behaves_like :successful_tree_rows_count
    #       end
    #       describe '- check ProfileKey have rows count - Ok' do
    #         let(:rows_qty) {36}
    #         it_behaves_like :successful_profile_keys_rows_count
    #       end
    #       describe '- check all relations generated in ProfileKey rows - Ok'  do  # , focus: true
    #         let(:relations_ids_arr) {[1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 5, 5, 7, 7, 8, 8, 13, 14, 14, 17, 17, 17,
    #                                   91, 101, 101, 101, 111, 111, 121, 121, 191, 221]}
    #         let(:relations_arr_size) {36}
    #         it_behaves_like :successful_profile_keys_relation_ids
    #       end
    #       describe '- check all profile_ids generated in ProfileKey rows - Ok' do
    #         let(:profiles_ids_arr) {[85, 85, 85, 85, 85, 85, 86, 86, 86, 86, 86, 86, 87, 87, 87, 87, 87, 87, 88, 88, 88,
    #                                  88, 88, 91, 91, 91, 91, 91, 92, 92, 92, 92, 173, 173, 173, 173]}
    #         let(:profiles_ids_arr_size) {36}
    #         it_behaves_like :successful_profile_keys_profile_ids
    #       end
    #     end
    #
    #   end
    #
    #   describe ' Check action <rollback_destroy_one_profile> :' do
    #     context '- rollback destroy profile = 90 - check tables values ' do
    #
    #       let(:destroy_log_data) { {:current_user => current_user_9, :log_type => 2, :profile_id => 90,
    #                                 :base_profile_id => 85, :relation_id => 3   } }
    #       before { CommonLog.rollback_add_one_profile(destroy_log_data) }
    #
    #       describe '- check CommonLog have rows count - Ok' do
    #         let(:rows_qty) {3}
    #         it_behaves_like :successful_common_logs_rows_count
    #       end
    #       it '- check CommonLog 1st row - Ok' do
    #         common_log_first =  CommonLog.first
    #         # puts "before action: trees_count = #{trees_count.inspect} \n"
    #         expect(common_log_first.profile_id).to eq(89)
    #         expect(common_log_first.id).to eq(1)
    #       end
    #       it '- check CommonLog 2nd row - Ok' do
    #         common_log_second =  CommonLog.second
    #         # puts "before action: trees_count = #{trees_count.inspect} \n"
    #         expect(common_log_second.profile_id).to eq(172)
    #         expect(common_log_second.id).to eq(3)
    #       end
    #       it '- check CommonLog 3rd row - Ok' do
    #         common_log_third =  CommonLog.third
    #         # puts "before action: trees_count = #{trees_count.inspect} \n"
    #         expect(common_log_third.profile_id).to eq(173)
    #         expect(common_log_third.id).to eq(4)
    #       end
    #       describe '- check Tree have rows count - Ok' do
    #         let(:rows_qty) {7}
    #         it_behaves_like :successful_tree_rows_count
    #       end
    #       describe '- check ProfileKey have rows count - Ok' do
    #         let(:rows_qty) {46}
    #         it_behaves_like :successful_profile_keys_rows_count
    #       end
    #       describe '- check all relations generated in ProfileKey rows - Ok' do  # , focus: true
    #         let(:relations_ids_arr) {[1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 5, 5, 7, 7, 7, 8, 8, 8, 13, 13, 14,
    #                                   14, 17, 17, 17, 17, 91, 91, 91, 101, 101, 101, 111, 111, 111, 111, 121, 121, 191,
    #                                   221]}
    #         let(:relations_arr_size) {46}
    #         it_behaves_like :successful_profile_keys_relation_ids
    #       end
    #       describe '- check all relations generated in ProfileKey rows - Ok'  do  # , focus: true
    #         let(:relations_ids_arr) {[1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 5, 5, 7, 7, 7, 8, 8, 8, 13, 13, 14,
    #                                   14, 17, 17, 17, 17, 91, 91, 91, 101, 101, 101, 111, 111, 111, 111, 121, 121, 191,
    #                                   221]}
    #         let(:relations_arr_size) {46}
    #         it_behaves_like :successful_profile_keys_relation_ids
    #       end
    #       describe '- check all profile_ids generated in ProfileKey rows - Ok' do
    #         let(:profiles_ids_arr) {[85, 85, 85, 85, 85, 85, 85, 86, 86, 86, 86, 86, 86, 86, 87, 87, 87, 87, 87, 87, 87,
    #                                  88, 88, 88, 88, 88, 88, 91, 91, 91, 91, 91, 92, 92, 92, 92, 172, 172, 172, 172, 172,
    #                                  173, 173, 173, 173, 173]}
    #         let(:profiles_ids_arr_size) {46}
    #         it_behaves_like :successful_profile_keys_profile_ids
    #       end
    #     end
    #
    #     context '- rollback destroy profile = 89 - check tables values ' do  # , focus: true
    #
    #       let(:destroy_log_data) { {:current_user => current_user_9, :log_type => 2, :profile_id => 89,
    #                                 :base_profile_id => 85, :relation_id => 6 } }
    #       before { CommonLog.rollback_add_one_profile(destroy_log_data) }
    #
    #       describe '- check CommonLog have rows count - Ok' do
    #         let(:rows_qty) {3}
    #         it_behaves_like :successful_common_logs_rows_count
    #       end
    #       it '- check CommonLog 1st row - Ok' do
    #         common_log_first =  CommonLog.first
    #         # puts "before action: trees_count = #{trees_count.inspect} \n"
    #         expect(common_log_first.profile_id).to eq(90) # got profile_id
    #         expect(common_log_first.id).to eq(2) # got id rows of CommonLog
    #       end
    #       it '- check CommonLog 2nd row - Ok' do
    #         common_log_second =  CommonLog.second
    #         # puts "before action: trees_count = #{trees_count.inspect} \n"
    #         expect(common_log_second.profile_id).to eq(172)
    #         expect(common_log_second.id).to eq(3)
    #       end
    #       it '- check CommonLog 3rd row - Ok' do
    #         common_log_third =  CommonLog.third
    #         # puts "before action: trees_count = #{trees_count.inspect} \n"
    #         expect(common_log_third.profile_id).to eq(173)
    #         expect(common_log_third.id).to eq(4)
    #       end
    #       describe '- check Tree have rows count - Ok' do
    #         let(:rows_qty) {7}
    #         it_behaves_like :successful_tree_rows_count
    #       end
    #       describe '- check ProfileKey have rows count - Ok' do
    #         let(:rows_qty) {46}
    #         it_behaves_like :successful_profile_keys_rows_count
    #       end
    #       describe '- check all relations generated in ProfileKey rows - Ok'  do  # , focus: true
    #         let(:relations_ids_arr) {[1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 5, 5, 7, 7, 7, 8, 8, 8, 13, 13, 14,
    #                                   14, 17, 17, 17, 17, 91, 91, 91, 101, 101, 101, 111, 111, 111, 111, 121, 121, 191,
    #                                   221]}
    #         let(:relations_arr_size) {46}
    #         it_behaves_like :successful_profile_keys_relation_ids
    #       end
    #       describe '- check all profile_ids generated in ProfileKey rows - Ok' do
    #         let(:profiles_ids_arr) {[85, 85, 85, 85, 85, 85, 85, 86, 86, 86, 86, 86, 86, 86, 87, 87, 87, 87, 87, 87, 87,
    #                                  88, 88, 88, 88, 88, 88, 91, 91, 91, 91, 91, 92, 92, 92, 92, 172, 172, 172, 172, 172,
    #                                  173, 173, 173, 173, 173]}
    #         let(:profiles_ids_arr_size) {46}
    #         it_behaves_like :successful_profile_keys_profile_ids
    #       end
    #     end



    # end

  end

end

