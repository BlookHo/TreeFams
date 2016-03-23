require 'rails_helper'

RSpec.describe TreeStats     do  #, focus: true

  describe 'Class TreeStat Before methods validation test'   do # , focus: true
    it "has a valid factory" do
      puts " Class TreeStats validation - has a valid factory"
      # expect(FactoryGirl.create(:weafam_stat)).to be_valid
    end
  end


  describe '- test TreeStats methods - ' do
    # create model data
    before {

      # Counter
      FactoryGirl.create(:counter_row)                        #  invites 2689,  disconnects 67

      #Weafam_settings
      FactoryGirl.create(:weafam_setting)    #

      # SearchResults
      FactoryGirl.create(:search_results)
      FactoryGirl.create(:search_results, :correct2)
      FactoryGirl.create(:search_results, :correct3)

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

      FactoryGirl.create(:connect_profile, :connect_profile_124)  # 124

      FactoryGirl.create(:connect_profile, :connect_profile_444)  # 444
      FactoryGirl.create(:connect_profile, :connect_profile_555)  # 555
      FactoryGirl.create(:connect_profile, :connect_profile_666)  # 666
      FactoryGirl.create(:connect_profile, :connect_profile_7777)  # 7777
      FactoryGirl.create(:connect_profile, :connect_profile_8888)  # 8888

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
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_49)   # 2  9
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_50)   # 9   2
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_51)   # 3  10
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_52)   # 10  3
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_53)   # 9   10
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_54)   # 10  9
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_55)   # 17  10
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_56)   # 10  17
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_57)   # 2   10
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_58)   # 10  2

      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_59)   # 11  12
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_60)   # 12  11
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_61)   # 11  13
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_62)   # 13  11
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_63)   # 12  13
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_64)   # 13  12
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_65)   # 11  14
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_66)   # 14  11
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_67)   # 12  14
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_68)   # 14  12
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_69)   # 13  14
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_70)   # 14  13
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_71)   # 11  15
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_72)   # 15  11
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_73)   # 12  15
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_74)   # 15  12
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_75)   # 13  15
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_76)   # 15  13
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_77)   # 14  15
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_78)   # 15  14
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_79)   # 11  16
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_80)   # 16  11
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_81)   # 15  16
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_82)   # 16  15
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_83)   # 12  16
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_84)   # 16  12
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_85)   # 13  16
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_86)   # 16  13
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_87)   # 14  16
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_88)   # 16  14
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_89)   # 11  17
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_90)   # 17  11
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_91)   # 15  17
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_92)   # 17  15
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_93)   # 16  17
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_94)   # 17  16
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_95)   # 12  17
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_96)   # 17  12
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_97)   # 13  17
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_98)   # 17  13
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_99)   # 12  18
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_100)  # 18  12
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_101)  # 11  18
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_102)  # 18  11
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_103)  # 14  18
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_104)  # 18  14
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_105)  # 13  18
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_106)  # 18  13
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_107)  # 12  19
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_108)  # 19  12
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_109)  # 18  19
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_110)  # 19  18
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_111)  # 14  19
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_112)  # 19  14
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_113)  # 11  19
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_114)  # 19  11
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_115)  # 13  19
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_116)  # 19  13
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_117)  # 13  20
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_118)  # 20  13
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_119)  # 14  20
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_120)  # 20  14
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_121)  # 11  20
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_122)  # 20  11
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_123)  # 12  20
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_124)  # 20  12
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_125)  # 13  21
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_126)  # 21  13
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_127)  # 20  21
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_128)  # 21  20
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_129)  # 14  21
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_130)  # 21  14
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_131)  # 11  21
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_132)  # 21  11
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_133)  # 12  21
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_134)  # 21  12

      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_135)  # 22  23
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_136)  # 23  22
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_137)  # 22  24
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_138)  # 24  22
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_139)  # 23  24
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_140)  # 24  23
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_141)  # 22  25
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_142)  # 25  22
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_143)  # 23  25
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_144)  # 25  23
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_145)  # 24  25
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_146)  # 25  24
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_147)  # 23  26
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_148)  # 26  23
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_149)  # 22  26
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_150)  # 26  22
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_151)  # 25  26
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_152)  # 26  25
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_153)  # 24  26
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_154)  # 26  24
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_155)  # 23  27
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_156)  # 27  23
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_157)  # 26  27
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_158)  # 27  26
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_159)  # 22  27
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_160)  # 27  22
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_161)  # 25  27
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_162)  # 27  25
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_163)  # 24  27
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_164)  # 27  24
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_165)  # 24  28
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_166)  # 28  24
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_167)  # 22  28
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_168)  # 28  22
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_169)  # 25  28
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_170)  # 28  25
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_171)  # 23  28
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_172)  # 28  23
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_173)  # 24  29
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_174)  # 29  24
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_175)  # 28  29
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_176)  # 29  28
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_177)  # 22  29
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_178)  # 29  22
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_179)  # 25  29
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_180)  # 29  25
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_181)  # 23  29
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_3_182)  # 29  23

      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_183)  # 11  14
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_184)  # 14  11
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_185)  # 15  14
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_186)  # 14  15
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_187)  # 16  14
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_1_188)  # 14  16

      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_189)  # 15  124
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_190)  # 124 15
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_191)  # 17  124
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_192)  # 124 17
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_193)  # 11  124
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_194)  # 124 11
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_195)  # 16  124
      FactoryGirl.create(:connection_profile_keys, :connect_profile_key_2_196)  # 124 16

    }

    after {
      ConnectionRequest.delete_all
      ConnectionRequest.reset_pk_sequence
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
      ConnectionLog.delete_all
      ConnectionLog.reset_pk_sequence
      CommonLog.delete_all
      CommonLog.reset_pk_sequence
      UpdatesFeed.delete_all
      UpdatesFeed.reset_pk_sequence
      SearchResults.delete_all
      SearchResults.reset_pk_sequence
    }

    # create User parameters
    let(:current_user_1) { User.first }  # User = 1. Tree = [1,2]. profile_id = 17
    let(:currentuser_id) {current_user_1.id}  # id = 1
    let(:connected_users) { current_user_1.get_connected_users }  # [1,2]

    context '- before TreeStats actions - check connected_users'    do
      it "- Return proper connected_users Array result for current_user_id = 1" do
        puts "In TreeStatsSpec\nLet created: currentuser_id = #{currentuser_id} \n"   # 1
        puts "Check ConnectedUser Model methods \n"
        puts "Before All - connected_users created \n"  #
        expect(connected_users).to be_a_kind_of(Array)
      end
      it "- Return proper connected_users Array result for current_user_id = 1" do
        puts "Let created: connected_users = #{connected_users} \n"   # [1,2]
        expect(connected_users).to eq([1,2])
      end
    end

    context '- before TreeStats actions - check tables values '   do   #   , focus: true
      describe '- check User have double == 0 before - Ok' do
        it "- current_user.double == 0 check" do
          puts "Let created: current_user_1.double = #{current_user_1.double} \n"   # 0
          expect(current_user_1.double).to eq(0)
        end
      end

      describe '- check Profile have rows count before - Ok'   do
        let(:rows_qty) {32}
        it_behaves_like :successful_profiles_rows_count
        let(:profile) {Profile.find(17)}
        it "- Profile.find(17) check" do
          puts "Profile.find(17).id = #{profile.id} \n"   # 0
          expect(profile.id).to eq(17)
        end
      end
      describe '- check Tree have rows count before - Ok' do
        let(:rows_qty) {28}
        it_behaves_like :successful_tree_rows_count
      end
      describe '- check ProfileKey have rows count before - Ok' do
        let(:rows_qty) {196}
        it_behaves_like :successful_profile_keys_rows_count
      end
      describe '- check ConnectedUser have rows count before - Ok' do
        let(:rows_qty) {2}
        it_behaves_like :successful_connected_users_rows_count
      end
      describe '- check SearchResults have rows count before - Ok' do
        let(:rows_qty) {3}
        it_behaves_like :successful_search_results_rows_count
      end
    end

    describe 'in TreeStats: Check actions - '  , focus: true  do   #   , focus: true
      context '- before actions - check all_users_names '    do   #   , focus: true
        let(:users_names) { User.all_users_names }  # [1,2]
        it '- check current_user_1.id - Ok' do
          puts "before logged_actual_profiles: current_user_1.profile_id = #{current_user_1.profile_id.inspect} \n"
          expect(current_user_1.profile_id).to eq(17)
        end
        it '- check all_users_names: - ' do
          puts "all users_names =  #{users_names.inspect}"
          expect(users_names.sort).to eq(["Алексей", "Анна", "Вера", "Вячеслав", "Дарья", "Наталья", "Петр", "Таисия"])
        end
      end

      context '- check collect_tree_stats '    do   #   , focus: true
        let(:tree_stats) { TreeStats.collect_tree_stats(currentuser_id) }
        it '- check collect_tree_stats - Ok' do
          puts "tree_stats = #{tree_stats.inspect} \n"
          expect(tree_stats).to eq({:tree_profiles=>[17, 15, 9, 20, 16, 10, 3, 12, 13, 14, 21, 124, 18, 11, 8, 19, 2, 7],
                                    :connected_users=>[1, 2], :qty_of_tree_profiles=>18, :qty_of_tree_users=>2 })
        end
      end



    end

  end

end