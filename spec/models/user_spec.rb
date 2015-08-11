
RSpec.describe User, :type => :model  , focus: true  do  # , focus: true

  describe '- validation' do
    before do
      @user = User.new( email: "new@nn.nn", password: '1111', profile_id:  1)
      @user.save
      @user_profile = @user.profile_id

      @profile = Profile.new( user_id: @user_profile, profile_name: 45, relation_id: 2, display_name_id:  45)
      @profile.save
    end

    describe '- on create' do
      context '- when valid user' do
        let(:user) {FactoryGirl.build(:user)}
        it '- saves a valid user' do
          puts "Model User validation "
          expect(user).to be_valid
        end
      end

      context '- when invalid user' do
        let(:user) {FactoryGirl.build(:user, :wrong_email)}
        it '- does not save an invalid user' do
          # name = user.name
          # user.update_name
          # expect(name).to_not eq(user.name)
          expect(user).to_not be_valid
        end
      end
    end

    after do
      User.delete_all
      User.reset_pk_sequence
    end

  end

  describe '- Check method get_connected_users'   do  # , focus: true

    before do
      User.delete_all
      User.reset_pk_sequence
      ConnectedUser.delete_all
      ConnectedUser.reset_pk_sequence

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
      FactoryGirl.create(:user, :user_9 )  # User = 9 . Tree = 10. profile_id = 888
      FactoryGirl.create(:user, :user_10)  # User = 10. Tree = 10. profile_id = 888
      FactoryGirl.create(:user, :user_11)  # User = 11. Tree = 10. profile_id = 888
      FactoryGirl.create(:user, :user_12)  # User = 12. Tree = 10. profile_id = 888
      FactoryGirl.create(:user, :user_13)  # User = 13. Tree = 10. profile_id = 888

      FactoryGirl.create(:connected_user, )
      FactoryGirl.create(:connected_user, :connected_user_2)
      FactoryGirl.create(:connected_user, :connected_user_3)
      FactoryGirl.create(:connected_user, :connected_user_4)
      FactoryGirl.create(:connected_user, :connected_user_5)
      FactoryGirl.create(:connected_user, :connected_user_6)

      # puts "before 6. connected_user = #{ConnectedUser.find(6).user_id} \n"

    end

    after do
      ConnectedUser.delete_all
      ConnectedUser.reset_pk_sequence
      User.delete_all
      User.reset_pk_sequence
    end


    context '- 1. after action: Check proper result of proper data type ' do
      let(:current_user) { User.find(1) }
      let(:connected_users) { current_user.get_connected_users }
      it "- First Return proper Array Sorted result for current_user_id = 1" do
        puts "Check ConnectedUser in User Model \n"
        expect(connected_users).to be_a_kind_of(Array)
        expect(connected_users).to eq([1,2])
      end
    end

    context '- 2. after action: Check proper result of proper data type ' do
      let(:current_user) { User.find(2) }
      let(:connected_users) { current_user.get_connected_users }
      it "- Second Return proper Array Sorted result for current_user_id = 2" do
        expect(connected_users).to be_a_kind_of(Array)
        expect(connected_users).to eq([1,2])
      end
    end

    context '- 3. after action: Check proper result of proper data type ' do
      let(:current_user) { User.find(3) }
      let(:connected_users) { current_user.get_connected_users }
      it "- Third Return proper Array Sorted result for current_user_id = 3" do
        expect(connected_users).to be_a_kind_of(Array)
        expect(connected_users).to eq([3,9,10,11])
      end
    end

    context '- 4. after action: Check proper result of proper data type ' do
      let(:current_user) { User.find(4) }
      let(:connected_users) { current_user.get_connected_users }
      it "- Fourth Return proper Array Sorted result for current_user_id = 4" do
        expect(connected_users).to be_a_kind_of(Array)
        expect(connected_users).to eq([4,13])
      end
    end

    context '- 5. after action: Check proper result of proper data type ' do
      let(:current_user) { User.find(5) }
      let(:connected_users) { current_user.get_connected_users }
      it "- Fifth Return UNproper Type result for current_user_id = 5" do
        expect(connected_users).to_not be_a_kind_of(Hash)
        expect(connected_users).to_not eq([1,5])
      end
    end

    context '- 6. after action: Check proper result of proper data type ' do
      let(:current_user) { User.find(6) }
      let(:connected_users) { current_user.get_connected_users }
      it "- Sixth Return UNproper Array result for current_user_id = 6" do
        expect(connected_users).to be_a_kind_of(Array)
        expect(connected_users).to_not eq([1])
      end
    end

    context '- 7. after action: Check proper result of proper data type ' do
      let(:current_user) { User.find(7) }
      let(:connected_users) { current_user.get_connected_users }
      it "- Seventh Return proper Array not_[] result for current_user_id = 7" do
        # puts " 7. After get_connected_users - current_user_id = #{current_user_id} \n"
        # puts " 7. After get_connected_users - conn_users = #{connected_users} \n"
        expect(connected_users).to be_a_kind_of(Array)
        expect(connected_users).to_not eq([])
      end
    end

  end

  describe '- Check methods in User model'   do # , focus: true
    # create model data
    before {
      #Weafam_settings
      FactoryGirl.create(:weafam_setting)    #

      # SearchResults
      FactoryGirl.create(:search_results)
      FactoryGirl.create(:search_results, :correct2)

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

      #     # puts "before All: ProfileKey.last.user_id = #{ProfileKey.last.user_id} \n"  # user_id = 1
      #     # puts "before All: ProfileKey.last.name_id = #{ProfileKey.last.is_name_id} \n"  # name_id = 187
      #     # puts "before All: ProfileKey.count = #{ProfileKey.all.count} \n" # 112

      FactoryGirl.create(:connection_request, :conn_request_1_2)    #
      FactoryGirl.create(:connection_request, :conn_request_7_8)    #
      FactoryGirl.create(:connection_request, :conn_request_3_1)    #
      FactoryGirl.create(:connection_request, :conn_request_3_2)    #

      #     FactoryGirl.create(:common_log, :log_delete_profile_89)    #
      #     FactoryGirl.create(:common_log, :log_delete_profile_90)    #
      #     FactoryGirl.create(:common_log, :log_add_profile_172)    #
      #     FactoryGirl.create(:common_log, :log_add_profile_173)    #
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
      # WeafamSetting.delete_all
      # WeafamSetting.reset_pk_sequence
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
    context '- before actions - check tables values ' do   #   , focus: true
      describe '- check Profile have rows count before - Ok' do
        let(:rows_qty) {26}
        it_behaves_like :successful_profiles_rows_count
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
    end

    describe '- check User model Method <Search> - Ok'  do  # , focus: true

      # let(:connection_data) { {:who_connect => [1, 2], :with_whom_connect => [3],
      #                          :profiles_to_rewrite => [14, 21, 19, 11, 20, 12, 13, 18],
      #                          :profiles_to_destroy => [22, 29, 27, 25, 28, 23, 24, 26],
      #                          :current_user_id => 2, :user_id => 3,:connection_id => 3 } }

      let(:certain_koeff_for_connect) { WeafamSetting.first.certain_koeff }  # 4
      let(:search_results) { current_user_1.start_search(certain_koeff_for_connect) }

      it "- Check certain_koeff_for_connect before start_search" do
        puts "In User model: certain_koeff_for_connect = #{certain_koeff_for_connect} \n"   # 4
        expect(certain_koeff_for_connect).to eq(4)
      end
      it "- Check search_results[:connected_author_arr] after start_search" do
        puts "In User model: search_results[:connected_author_arr] = #{search_results[:connected_author_arr]} \n"
        expect(search_results[:connected_author_arr]).to eq([1,2])
      end
      it "- Check search_results[:qty_of_tree_profiles] after start_search" do
        puts "In User model: search_results[:qty_of_tree_profiles] = #{search_results[:qty_of_tree_profiles]} \n"
        expect(search_results[:qty_of_tree_profiles]).to eq(18)
      end
      it "- Check search_results[:profiles_relations_arr] after start_search" do
        puts "In User model: search_results[:profiles_relations_arr][0] = #{search_results[:profiles_relations_arr][0]} \n"
        expect(search_results[:profiles_relations_arr].sort_by { |hsh| hsh[:profile_searched] }).to eq([
        # преобразованная структура - такая же исп-ся в существующем search.rb
        {:profile_searched=>2, :profile_relations=>{7=>1, 8=>2, 17=>3, 3=>8, 9=>15, 10=>16, 11=>17, 15=>111, 16=>111}},
        {:profile_searched=>3, :profile_relations=>{9=>1, 10=>2, 17=>3, 2=>7, 7=>13, 8=>14, 11=>17, 15=>111, 16=>111}},
        {:profile_searched=>7, :profile_relations=>{2=>3, 8=>8, 3=>17, 17=>111}},
        {:profile_searched=>8, :profile_relations=>{2=>3, 7=>7, 3=>17, 17=>111}},
        {:profile_searched=>9, :profile_relations=>{3=>4, 10=>8, 2=>18, 17=>112}},
        {:profile_searched=>10, :profile_relations=>{3=>4, 9=>7, 2=>18, 17=>112}},
        {:profile_searched=>11, :profile_relations=>{12=>1, 13=>2, 15=>3, 16=>3, 14=>6, 17=>7, 2=>13, 3=>14, 18=>91, 20=>92, 19=>101, 21=>102, 124=>121}},
        {:profile_searched=>12, :profile_relations=>{18=>1, 19=>2, 11=>4, 14=>4, 13=>8, 20=>15, 21=>16, 17=>18, 15=>112, 16=>112}},
        {:profile_searched=>13, :profile_relations=>{20=>1, 21=>2, 11=>4, 14=>4, 12=>7, 18=>13, 19=>14, 17=>18, 15=>112, 16=>112}},
        {:profile_searched=>14, :profile_relations=>{12=>1, 13=>2, 11=>6, 18=>91, 20=>92, 19=>101, 21=>102, 15=>212, 16=>212}},
        {:profile_searched=>15, :profile_relations=>{17=>1, 11=>2, 124=>4, 16=>5, 2=>91, 12=>92, 3=>101, 13=>102, 14=>202}},
        {:profile_searched=>16, :profile_relations=>{17=>1, 11=>2, 15=>5, 2=>91, 12=>92, 3=>101, 13=>102, 14=>202, 124=>221}},
        {:profile_searched=>17, :profile_relations=>{2=>1, 3=>2, 15=>3, 16=>3, 11=>8, 12=>15, 13=>16, 7=>91, 9=>92, 8=>101, 10=>102, 124=>121}},
        {:profile_searched=>18, :profile_relations=>{12=>3, 19=>8, 13=>17, 11=>121, 14=>121}},
        {:profile_searched=>19, :profile_relations=>{12=>3, 18=>7, 13=>17, 11=>121, 14=>121}},
        {:profile_searched=>20, :profile_relations=>{13=>4, 21=>8, 12=>18, 11=>122, 14=>122}},
        {:profile_searched=>21, :profile_relations=>{13=>4, 20=>7, 12=>18, 11=>122, 14=>122}},
        {:profile_searched=>124, :profile_relations=>{15=>1, 17=>91, 11=>101, 16=>191}}
        ])
      end

      # преобразование структуры из существующего search.rb  для обеспечения сортировки для теста и
      # более корректного представления - для рефакторинга.
      let(:result_arr_of_hashes) {
        result_arr_of_hashes = []
        search_results[:profiles_found_arr].each do |one_hash|
          one_profile_hash = Hash.new
          one_hash.each do |k,v|
            one_profile_hash = { profile_searched: k, profiles_found: v}
          end
          result_arr_of_hashes << one_profile_hash
        end
        result_arr_of_hashes
      }
      it "- Check search_results[:profiles_found_arr] after start_search"  do
        # result_arr_of_hashes = [
        #     {:profile_searched=>15, :profiles_found=>{}}, {:profile_searched=>9, :profiles_found=>{}},
        #     {:profile_searched=>20, :profiles_found=>{3=>{28=>[4, 8, 18, 122, 122]}}},
        #     {:profile_searched=>16, :profiles_found=>{}}, {:profile_searched=>10, :profiles_found=>{}},
        #     {:profile_searched=>17, :profiles_found=>{}}, {:profile_searched=>3, :profiles_found=>{}},
        #     {:profile_searched=>12, :profiles_found=>{3=>{23=>[1, 2, 4, 4, 8, 15, 16]}}},
        #     {:profile_searched=>13, :profiles_found=>{3=>{24=>[1, 2, 4, 4, 7, 13, 14]}}},
        #     {:profile_searched=>14, :profiles_found=>{3=>{22=>[1, 2, 6, 91, 92, 101, 102]}}},
        #     {:profile_searched=>21, :profiles_found=>{3=>{29=>[4, 7, 18, 122, 122]}}},
        #     {:profile_searched=>124, :profiles_found=>{}},
        #     {:profile_searched=>18, :profiles_found=>{3=>{26=>[3, 8, 17, 121, 121]}}},
        #     {:profile_searched=>11, :profiles_found=>{3=>{25=>[1, 2, 6, 91, 92, 101, 102]}}},
        #     {:profile_searched=>8, :profiles_found=>{}},
        #     {:profile_searched=>19, :profiles_found=>{3=>{27=>[3, 7, 17, 121, 121]}}},
        #     {:profile_searched=>2, :profiles_found=>{}}, {:profile_searched=>7, :profiles_found=>{}}]
        puts "In User model: search_results[:profiles_found_arr][2] = #{search_results[:profiles_found_arr][2]} \n"
        expect(result_arr_of_hashes.sort_by { |hsh| hsh[:profile_searched] }).to eq( [
              # преобразованная структура
              {:profile_searched=>2, :profiles_found=>{}},
              {:profile_searched=>3, :profiles_found=>{}},
              {:profile_searched=>7, :profiles_found=>{}},
              {:profile_searched=>8, :profiles_found=>{}},
              {:profile_searched=>9, :profiles_found=>{}},
              {:profile_searched=>10, :profiles_found=>{}},
              {:profile_searched=>11, :profiles_found=>{3=>{25=>[1, 2, 6, 91, 92, 101, 102]}}},
              {:profile_searched=>12, :profiles_found=>{3=>{23=>[1, 2, 4, 4, 8, 15, 16]}}},
              {:profile_searched=>13, :profiles_found=>{3=>{24=>[1, 2, 4, 4, 7, 13, 14]}}},
              {:profile_searched=>14, :profiles_found=>{3=>{22=>[1, 2, 6, 91, 92, 101, 102]}}},
              {:profile_searched=>15, :profiles_found=>{}},
              {:profile_searched=>16, :profiles_found=>{}},
              {:profile_searched=>17, :profiles_found=>{}},
              {:profile_searched=>18, :profiles_found=>{3=>{26=>[3, 8, 17, 121, 121]}}},
              {:profile_searched=>19, :profiles_found=>{3=>{27=>[3, 7, 17, 121, 121]}}},
              {:profile_searched=>20, :profiles_found=>{3=>{28=>[4, 8, 18, 122, 122]}}},
              {:profile_searched=>21, :profiles_found=>{3=>{29=>[4, 7, 18, 122, 122]}}},
              {:profile_searched=>124, :profiles_found=>{}}]
                                                                                 )
        # [     # Структура - из существующего search.rb
        # {15=>{}},    {9=>{}},     {20=>{3=>{28=>[4, 8, 18, 122, 122]}}},
        # {16=>{}},
        # {10=>{}},
        # {17=>{}},
        # {3=>{}},
        # {12=>{3=>{23=>[1, 2, 4, 4, 8, 15, 16]}}},
        # {13=>{3=>{24=>[1, 2, 4, 4, 7, 13, 14]}}},
        # {14=>{3=>{22=>[1, 2, 6, 91, 92, 101, 102]}}},
        # {21=>{3=>{29=>[4, 7, 18, 122, 122]}}},
        # {124=>{}},
        # {18=>{3=>{26=>[3, 8, 17, 121, 121]}}},
        # {11=>{3=>{25=>[1, 2, 6, 91, 92, 101, 102]}}},
        # {8=>{}},
        # {19=>{3=>{27=>[3, 7, 17, 121, 121]}}},
        # {2=>{}},
        # {7=>{}}]
      end
      it "- Check search_results[:uniq_profiles_pairs] after start_search"  do
        puts "In User model: search_results[:uniq_profiles_pairs] = #{search_results[:uniq_profiles_pairs]} \n"
        # Структура - из существующего search.rb
        # uniq_profiles_pairs =
        # {20=>{3=>28}, 12=>{3=>23}, 13=>{3=>24}, 14=>{3=>22}, 21=>{3=>29}, 18=>{3=>26}, 11=>{3=>25}, 19=>{3=>27}}
        # или
        #  uniq_profiles_pairs = {135=>{12=>94}, 129=>{12=>110, 13=>110, 14=>104}} - перед
        # init_connection_hash = make_init_connection_hash(with_whom_connect_users_arr, uniq_profiles_pairs)
        expect(search_results[:uniq_profiles_pairs].sort_by { |k,v| k }).to eq(
              # преобразованная структура
              [[11, {3=>25}], [12, {3=>23}], [13, {3=>24}], [14, {3=>22}], [18, {3=>26}], [19, {3=>27}],
               [20, {3=>28}], [21, {3=>29}]] )
        # init_connection_hash = {14=>22, 21=>29, 19=>27, 11=>25, 20=>28, 12=>23, 13=>24, 18=>26}  - перед
        # profiles_to_rewrite, profiles_to_destroy = hard_complete_search(init_connection_hash)
      end
      it "- Check search_results[:profiles_with_match_hash] after start_search"  do
        puts "In User model: search_results[:profiles_with_match_hash] = #{search_results[:profiles_with_match_hash]} \n"
        # Структура - из существующего search.rb
        # {25=>7, 22=>7, 24=>7, 23=>7, 27=>5, 26=>5, 29=>5, 28=>5}
        expect(search_results[:profiles_with_match_hash].sort_by { |k,v| k }).to eq(
              [[22, 7], [23, 7], [24, 7], [25, 7], [26, 5], [27, 5], [28, 5], [29, 5]] )
        # преобразованная структура
      end
      it "- Check search_results[:by_profiles] after start_search" do
        puts "In User model: search_results[:by_profiles][3] = #{search_results[:by_profiles][3]} \n"
        expect(search_results[:by_profiles].sort_by { |hsh| hsh[:search_profile_id] }).to eq( [
        # Сортированная структура - из существующего search.rb
        {:search_profile_id=>11, :found_tree_id=>3, :found_profile_id=>25, :count=>7},
        {:search_profile_id=>12, :found_tree_id=>3, :found_profile_id=>23, :count=>7},
        {:search_profile_id=>13, :found_tree_id=>3, :found_profile_id=>24, :count=>7},
        {:search_profile_id=>14, :found_tree_id=>3, :found_profile_id=>22, :count=>7},
        {:search_profile_id=>18, :found_tree_id=>3, :found_profile_id=>26, :count=>5},
        {:search_profile_id=>19, :found_tree_id=>3, :found_profile_id=>27, :count=>5},
        {:search_profile_id=>20, :found_tree_id=>3, :found_profile_id=>28, :count=>5},
        {:search_profile_id=>21, :found_tree_id=>3, :found_profile_id=>29, :count=>5}])
      end

      let(:found_profiles_arr_sorted) { search_results[:by_trees][0][:found_profile_ids].sort }
      let(:found_tree) { search_results[:by_trees][0][:found_tree_id] }
      it "- Check search_results[:by_trees] after start_search"  do  #, focus: true
        puts "In User model: search_results[:by_trees] = #{search_results[:by_trees]} \n"
        # Структура - из существующего search.rb
        # search_results[:by_trees] = {:found_tree_id=>3, :found_profile_ids=>[28, 23, 24, 22, 29, 26, 25, 27]}
        expect(found_tree).to eq(3)
        expect(found_profiles_arr_sorted).to eq([22, 23, 24, 25, 26, 27, 28, 29])
      end
      it "- Check search_results[:duplicates_one_to_many] after start_search" do
        puts "In User model: search_results[:duplicates_one_to_many] = #{search_results[:duplicates_one_to_many]} \n"
        expect(search_results[:duplicates_one_to_many]).to eq({})
      end
      it "- Check search_results[:duplicates_many_to_one] after start_search" do
        puts "In User model: search_results[:duplicates_many_to_one] = #{search_results[:duplicates_many_to_one]} \n"
        expect(search_results[:duplicates_many_to_one]).to eq({})
      end

      # search_results = {:connected_author_arr=>[1, 2], :qty_of_tree_profiles=>18,
      # :profiles_relations_arr=>[
      # {15=>{17=>1, 11=>2, 124=>4, 16=>5, 2=>91, 12=>92, 3=>101, 13=>102, 14=>202}},
      # {9=>{3=>4, 10=>8, 2=>18, 17=>112}},
      # {20=>{13=>4, 21=>8, 12=>18, 11=>122, 14=>122}},
      # {16=>{17=>1, 11=>2, 15=>5, 2=>91, 12=>92, 3=>101, 13=>102, 14=>202, 124=>221}},
      # {10=>{3=>4, 9=>7, 2=>18, 17=>112}},
      # {17=>{2=>1, 3=>2, 15=>3, 16=>3, 11=>8, 12=>15, 13=>16, 7=>91, 9=>92, 8=>101, 10=>102, 124=>121}},
      # {3=>{9=>1, 10=>2, 17=>3, 2=>7, 7=>13, 8=>14, 11=>17, 15=>111, 16=>111}},
      # {12=>{18=>1, 19=>2, 11=>4, 14=>4, 13=>8, 20=>15, 21=>16, 17=>18, 15=>112, 16=>112}},
      # {13=>{20=>1, 21=>2, 11=>4, 14=>4, 12=>7, 18=>13, 19=>14, 17=>18, 15=>112, 16=>112}},
      # {14=>{12=>1, 13=>2, 11=>6, 18=>91, 20=>92, 19=>101, 21=>102, 15=>212, 16=>212}},
      # {21=>{13=>4, 20=>7, 12=>18, 11=>122, 14=>122}},
      # {124=>{15=>1, 17=>91, 11=>101, 16=>191}},
      # {18=>{12=>3, 19=>8, 13=>17, 11=>121, 14=>121}},
      # {11=>{12=>1, 13=>2, 15=>3, 16=>3, 14=>6, 17=>7, 2=>13, 3=>14, 18=>91, 20=>92, 19=>101, 21=>102, 124=>121}},
      # {8=>{2=>3, 7=>7, 3=>17, 17=>111}},
      # {19=>{12=>3, 18=>7, 13=>17, 11=>121, 14=>121}},
      # {2=>{7=>1, 8=>2, 17=>3, 3=>8, 9=>15, 10=>16, 11=>17, 15=>111, 16=>111}},
      # {7=>{2=>3, 8=>8, 3=>17, 17=>111}}],
      # :profiles_found_arr=>[
      # {15=>{}},
      # {9=>{}},
      # {20=>{3=>{28=>[4, 8, 18, 122, 122]}}},
      # {16=>{}},
      # {10=>{}},
      # {17=>{}},
      # {3=>{}},
      # {12=>{3=>{23=>[1, 2, 4, 4, 8, 15, 16]}}},
      # {13=>{3=>{24=>[1, 2, 4, 4, 7, 13, 14]}}},
      # {14=>{3=>{22=>[1, 2, 6, 91, 92, 101, 102]}}},
      # {21=>{3=>{29=>[4, 7, 18, 122, 122]}}},
      # {124=>{}},
      # {18=>{3=>{26=>[3, 8, 17, 121, 121]}}},
      # {11=>{3=>{25=>[1, 2, 6, 91, 92, 101, 102]}}},
      # {8=>{}},
      # {19=>{3=>{27=>[3, 7, 17, 121, 121]}}},
      # {2=>{}},
      # {7=>{}}],
      # :uniq_profiles_pairs=>{
      # 20=>{3=>28}, 12=>{3=>23}, 13=>{3=>24}, 14=>{3=>22}, 21=>{3=>29}, 18=>{3=>26}, 11=>{3=>25}, 19=>{3=>27}},
      # :profiles_with_match_hash=>{25=>7, 22=>7, 24=>7, 23=>7, 27=>5, 26=>5, 29=>5, 28=>5},
      # :by_profiles=>[
      # {:search_profile_id=>11, :found_tree_id=>3, :found_profile_id=>25, :count=>7},
      # {:search_profile_id=>14, :found_tree_id=>3, :found_profile_id=>22, :count=>7},
      # {:search_profile_id=>13, :found_tree_id=>3, :found_profile_id=>24, :count=>7},
      # {:search_profile_id=>12, :found_tree_id=>3, :found_profile_id=>23, :count=>7},
      # {:search_profile_id=>19, :found_tree_id=>3, :found_profile_id=>27, :count=>5},
      # {:search_profile_id=>18, :found_tree_id=>3, :found_profile_id=>26, :count=>5},
      # {:search_profile_id=>21, :found_tree_id=>3, :found_profile_id=>29, :count=>5},
      # {:search_profile_id=>20, :found_tree_id=>3, :found_profile_id=>28, :count=>5}],
      # :by_trees=>[
      # {:found_tree_id=>3, :found_profile_ids=>[28, 23, 24, 22, 29, 26, 25, 27]}],
      # :duplicates_one_to_many=>{}, :duplicates_many_to_one=>{}}


    end

    context '- check SearchResults model after run <search> module'   do #  ,  focus: true
      let(:certain_koeff_for_connect) { WeafamSetting.first.certain_koeff }  # 4
      before { current_user_1.start_search(certain_koeff_for_connect) }
      describe '- check SearchResults have rows count after <search> - Ok' do
        let(:rows_qty) {3}
        it_behaves_like :successful_search_results_rows_count
      end
      it '- check SearchResults First Factory row - Ok' do # , focus: true
        search_results_fields = SearchResults.first.attributes.except('created_at','updated_at')
        expect(search_results_fields).to eq({"id"=>1, "user_id"=>15, "found_user_id"=>35, "profile_id"=>5,
                                             "found_profile_id"=>7, "count"=>4, "found_profile_ids"=>[7, 25],
                                             "searched_profile_ids"=>[5, 52], "counts"=>[4, 4],
                                             "connection_id"=>nil, "pending_connect"=>0} )
      end
      it '- check SearchResults Second Factory row - Ok' do # , focus: true
        search_results_fields = SearchResults.second.attributes.except('created_at','updated_at')
        expect(search_results_fields).to eq({"id"=>2, "user_id"=>2, "found_user_id"=>3, "profile_id"=>1555,
                                             "found_profile_id"=>1444, "count"=>5, "found_profile_ids"=>[1444, 22222],
                                             "searched_profile_ids"=>[1555, 27777], "counts"=>[5, 5],
                                             "connection_id"=>7, "pending_connect"=>1}  )
      end
      it '- check SearchResults Third row - made by Method Search - Ok' do # , focus: true
        search_results_fields = SearchResults.third.attributes.except('created_at','updated_at','found_profile_ids',
                                                                      'searched_profile_ids')
        expect(search_results_fields).to eq({"id"=>3, "user_id"=>1, "found_user_id"=>3, "profile_id"=>11,
                                             "found_profile_id"=>25, "count"=>7,
                                             "counts"=>[7, 7, 7, 7, 5, 5, 5, 5], "connection_id"=>3,
                                             "pending_connect"=>0} )
      end
      it '- check SearchResults Third row.found_profile_ids - made by Method Search - Ok' do
        search_results_fields = SearchResults.third.found_profile_ids.sort
        expect(search_results_fields).to eq( [22, 23, 24, 25, 26, 27, 28, 29])
      end
      it '- check SearchResults Third row.searched_profile_ids - made by Method Search - Ok' do
        search_results_fields = SearchResults.third.searched_profile_ids.sort
        expect(search_results_fields).to eq( [11, 12, 13, 14, 18, 19, 20, 21])
      end
      it '- check SearchResults Third row.counts - made by Method Search - Ok' do
        search_results_fields = SearchResults.third.counts.sort
        expect(search_results_fields).to eq( [5, 5, 5, 5, 7, 7, 7, 7])
      end

    end


    describe '- check User model Method <complete_search> - Ok'    do  # , focus: true

      # [inf] with_whom_connect_users_arr = [3], uniq_profiles_pairs = {15=>{9=>85, 11=>128}, 14=>{3=>22}, 21=>{3=>29}, 19=>{3=>27}, 11=>{3=>25, 11=>127, 9=>87}, 2=>{9=>172, 11=>139}, 20=>{3=>28}, 16=>{9=>88, 11=>125}, 17=>{9=>86, 11=>126}, 12=>{3=>23, 11=>155}, 3=>{9=>173, 11=>154}, 13=>{3=>24, 11=>156}, 124=>{9=>91}, 18=>{3=>26}} (pid:4353)
      context '- when valid complete_search_data' do
        let(:complete_search_data) { {
            :with_whom_connect => [3],
            :uniq_profiles_pairs => { #15=>{9=>85, 11=>128}, 14=>{3=>22}, 21=>{3=>29}, 19=>{3=>27},
                                      # 11=>{3=>25, 11=>127, 9=>87}, 2=>{9=>172, 11=>139},
                                     20=>{3=>28} }#,
                                     # 16=>{9=>88, 11=>125}, 17=>{9=>86, 11=>126}, 12=>{3=>23, 11=>155} }  #,
                                     # 3=>{9=>173, 11=>154}, 13=>{3=>24, 11=>156}, 124=>{9=>91}, 18=>{3=>26}}
        } }

        let(:certain_koeff_for_connect) { WeafamSetting.first.certain_koeff }  # 4
        let(:final_connection_hash) { current_user_1.complete_search(complete_search_data) }

        it "- Check Valid Complete search result: final_connection_hash after <complete_search>" do
          puts "In User model: final_connection_hash = #{final_connection_hash} \n"
          expect(final_connection_hash).to eq( {14=>22, 21=>29, 19=>27, 11=>25, 20=>28, 12=>23, 13=>24, 18=>26} )
        end
      end

      context '- when Invalid complete_search_data - with_whom_connect: wrong = [4]' do
        let(:complete_search_data) { {
            :with_whom_connect => [4],
            :uniq_profiles_pairs => { 15=>{9=>85, 11=>128}, 14=>{3=>22}, 21=>{3=>29}, 19=>{3=>27},
                                      11=>{3=>25, 11=>127, 9=>87}, 2=>{9=>172, 11=>139},
                                      20=>{3=>28}, 16=>{9=>88, 11=>125}, 17=>{9=>86, 11=>126}, 12=>{3=>23, 11=>155} ,
                                      3=>{9=>173, 11=>154}, 13=>{3=>24, 11=>156}, 124=>{9=>91}, 18=>{3=>26}}
        } }

        let(:certain_koeff_for_connect) { WeafamSetting.first.certain_koeff }  # 4
        let(:final_connection_hash) { current_user_1.complete_search(complete_search_data) }

        it "- Check Invalid Complete search result: final_connection_hash == {} " do
          puts "In User model: with_whom_connect: wrong - final_connection_hash = #{final_connection_hash} \n"
          expect(final_connection_hash).to eq( {} )
        end
        it "- Check Invalid Complete search result: final_connection_hash - incorrect" do
          puts "In User model: final_connection_hash - wrong: #{final_connection_hash} \n"
          expect(final_connection_hash).to_not eq( {14=>22, 21=>29, 19=>27, 11=>25, 20=>28, 12=>23, 13=>24} )
        end
      end

    end

    #  connection_data = {:who_connect=>[1, 2], :with_whom_connect=>[3],
    # :profiles_to_rewrite=>[14, 21, 19, 11, 20, 12, 13, 18], :profiles_to_destroy=>[22, 29, 27, 25, 28, 23, 24, 26],
    # :current_user_id=>1, :user_id=>3, :connection_id=>3}
    describe '- check User model Method < check_connection_arrs(connection_data )>'  do  # , focus: true
      context '- when valid connection_data' do
        let(:connection_data) {{:who_connect_arr=>[1, 2], :with_whom_connect_arr=>[3],
                                :profiles_to_rewrite=>[14, 21, 19, 11, 20, 12, 13, 18],
                                :profiles_to_destroy=>[22, 29, 27, 25, 28, 23, 24, 26],
                                :current_user_id=>1, :user_id=>3, :connection_id=>3} }
        let(:check_connection_result) { current_user_1.check_connection_arrs(connection_data) }
         # check_connection_result = {:stop_by_arrs=>false,
         # :diag_connection_message=>"Ok to connect. НЕТ Дублирований in Connection array(s) "}

        it "- check_connection_result: after <check_connection_arrs>" do
          puts "In User model: check_connection_result[:stop_by_arrs] = #{check_connection_result[:stop_by_arrs]} \n"
          expect(check_connection_result[:stop_by_arrs]).to eq( false )
        end
        it "- check_connection_result: after <check_connection_arrs>" do
          puts "In User model: check_connection_result[:diag_connection_message]
                 = #{check_connection_result[:diag_connection_message]} \n"
          expect(check_connection_result[:diag_connection_message]).
              to eq( "Данные для объединения деревьев - корректны. " )
        end
        it "- check_connection_result: after <check_connection_arrs>" do
          puts "In User model: check_connection_result[:common_profiles] = #{check_connection_result[:common_profiles]} \n"
          expect(check_connection_result[:common_profiles]).to eq( [] )
        end
        it "- check_connection_result: after <check_connection_arrs>" do
          puts "In User model: check_connection_result[:complete_dubles_hash]
                = #{check_connection_result[:complete_dubles_hash]} \n"
          expect(check_connection_result[:complete_dubles_hash]).to eq( {} )
        end

      end
      context '- when Invalid connection_data 1 ' do
        let(:connection_data) {{:who_connect_arr=>[1, 2], :with_whom_connect_arr=>[3],
                                :profiles_to_rewrite=>[14, 21, 19, 11, 20, 12, 13, 18],
                                :profiles_to_destroy=>[22, 29, 27, 25, 28, 12, 24, 18],
                                :current_user_id=>1, :user_id=>3, :connection_id=>3} }
        let(:check_connection_result) { current_user_1.check_connection_arrs(connection_data) }
        it "- check_connection_result when the same profile (12 и 18) - is in both arrays" do
          puts "In User model check_connection_arrs wrong: same profile (12 и 18):
                 check_connection_result[:stop_by_arrs] =  #{check_connection_result[:stop_by_arrs]} \n"
          expect(check_connection_result[:stop_by_arrs]).to eq( true )
        end
        it "- check_connection_result: when the same profile (12 и 18) - is in both arrays: connection_message " do
          puts "In User model check_connection_arrs wrong: same profile (12 и 18) - is in both arrays:
                 check_connection_result[:diag_connection_message] =  #{check_connection_result[:diag_connection_message]} \n"
          expect(check_connection_result[:diag_connection_message]).
              to eq( "Объединение остановлено. В массивах объединения - есть общие (совпадающие) профили!" )
        end
        it "- check_connection_result: when the same profile (12 и 18) - is in both arrays: common_profiles" do
          puts "In User model: check_connection_result[:common_profiles] = #{check_connection_result[:common_profiles]} \n"
          expect(check_connection_result[:common_profiles]).to eq( [12, 18] )
        end
        it "- check_connection_result: when the same profile (12 и 18) - is in both arrays: complete_dubles_hash" do
          puts "In User model: check_connection_result[:complete_dubles_hash]
                = #{check_connection_result[:complete_dubles_hash]} \n"
          expect(check_connection_result[:complete_dubles_hash]).to eq( {} )
        end
      end

      context '- when Invalid connection_data 2 ' do
        let(:connection_data) {{:who_connect_arr=>[1, 2], :with_whom_connect_arr=>[3],
                                :profiles_to_rewrite=>[], :profiles_to_destroy=>[22, 29, 27, 25, 28, 23, 24, 26],
                                :current_user_id=>1, :user_id=>3, :connection_id=>3} }
        let(:check_connection_result) { current_user_1.check_connection_arrs(connection_data) }
        it "- check_connection_result when profiles_to_rewrite = [] - stop_by_arrs = true" do
          puts "In User model check_connection_arrs wrong: profiles_to_rewrite = []:
                 check_connection_result[:stop_by_arrs] =  #{check_connection_result[:stop_by_arrs]} \n"
          expect(check_connection_result[:stop_by_arrs]).to eq( true )
        end
        it "- check_connection_result: when profiles_to_rewrite = [] - connection_message " do
          puts "In User model check_connection_arrs wrong: profiles_to_rewrite = []:
                 check_connection_result[:diag_connection_message] =  #{check_connection_result[:diag_connection_message]} \n"
          expect(check_connection_result[:diag_connection_message]).
              to eq( "Объединение остановлено, т.к. массив(ы) объединения - пустые" )
        end
        it "- check_connection_result: when profiles_to_rewrite = [] - common_profiles" do
          puts "In User model: check_connection_result[:common_profiles] = #{check_connection_result[:common_profiles]} \n"
          expect(check_connection_result[:common_profiles]).to eq( [] )
        end
        it "- check_connection_result: when profiles_to_rewrite = [] - complete_dubles_hash" do
          puts "In User model: check_connection_result[:complete_dubles_hash]
                 = #{check_connection_result[:complete_dubles_hash]} \n"
          expect(check_connection_result[:complete_dubles_hash]).to eq( {} )
        end
      end

      context '- when Invalid connection_data 3 '  do   # , focus: true
        let(:connection_data) {{:who_connect_arr=>[1, 2], :with_whom_connect_arr=>[3],
                                :profiles_to_rewrite=>[14, 21, 19, 11, 20, 12], #, 13, 18],
                                :profiles_to_destroy=>[22, 29, 27, 25, 28, 23, 24, 26],
                                :current_user_id=>1, :user_id=>3, :connection_id=>3} }
        let(:check_connection_result) { current_user_1.check_connection_arrs(connection_data) }
        it "- check_connection_result when arrays size are unqual - stop_by_arrs = true" do
          puts "In User model check_connection_arrs wrong: arrays size are unqual:
                 check_connection_result[:stop_by_arrs] =  #{check_connection_result[:stop_by_arrs]} \n"
          expect(check_connection_result[:stop_by_arrs]).to eq( true )
        end
        it "- check_connection_result: when arrays size are unqual - connection_message " do
          puts "In User model check_connection_arrs wrong: profiles_to_rewrite = []:
                 check_connection_result[:diag_connection_message] =  #{check_connection_result[:diag_connection_message]} \n"
          expect(check_connection_result[:diag_connection_message]).
              to eq( "Объединение остановлено, т.к. массив(ы) объединения - имеют разный размер" )
        end
        it "- check_connection_result: when arrays size are unqual - common_profiles" do
          puts "In User model: check_connection_result[:common_profiles] = #{check_connection_result[:common_profiles]} \n"
          expect(check_connection_result[:common_profiles]).to eq( [] )
        end
        it "- check_connection_result: when arrays size are unqual - complete_dubles_hash" do
          puts "In User model: check_connection_result[:complete_dubles_hash]
                 = #{check_connection_result[:complete_dubles_hash]} \n"
          expect(check_connection_result[:complete_dubles_hash]).to eq( {} )
        end
      end

      context '- when Invalid connection_data 4 '  do   # , focus: true
        let(:connection_data) {{:who_connect_arr=>[1, 2], :with_whom_connect_arr=>[3],
                                :profiles_to_rewrite=>[14, 21, 19, 11, 20, 12, 13, 11],
                                :profiles_to_destroy=>[22, 29, 27, 25, 28, 23, 24, 26],
                                :current_user_id=>1, :user_id=>3, :connection_id=>3} }
        let(:check_connection_result) { current_user_1.check_connection_arrs(connection_data) }
        it "- check_connection_result when dubles in rewrite array (11) - stop_by_arrs = true" do
          puts "In User model check_connection_arrs wrong: dubles in arrays:
                 check_connection_result[:stop_by_arrs] =  #{check_connection_result[:stop_by_arrs]} \n"
          expect(check_connection_result[:stop_by_arrs]).to eq( true )
        end
        it "- check_connection_result: when dubles in rewrite array (11) - connection_message " do
          puts "In User model check_connection_arrs wrong: dubles in arrays:
                 check_connection_result[:diag_connection_message] =  #{check_connection_result[:diag_connection_message]} \n"
          expect(check_connection_result[:diag_connection_message]).
              to eq( "Нельзя объединить ваши деревья, т.к. данные для объединения - некорректны! ЕСТЬ дублирования в массивах" )
        end
        it "- check_connection_result: when dubles in rewrite array (11) - common_profiles" do
          puts "In User model: check_connection_result[:common_profiles] = #{check_connection_result[:common_profiles]} \n"
          expect(check_connection_result[:common_profiles]).to eq( [] )
        end
        it "- check_connection_result: when dubles in rewrite array (11):
                         profile 11 to profiles 25 and 26 - complete_dubles_hash" do
          puts "In User model: check_connection_result[:complete_dubles_hash] =
                 #{check_connection_result[:complete_dubles_hash]} \n"
          expect(check_connection_result[:complete_dubles_hash]).to eq(  {11=>[25, 26]} )
        end
      end

    end

    ################ CONNECTION - DISCONNECTION ###########################

    describe '- check User model Method <connect_trees(connection_data)> - Ok'  do  # , focus: true
      context '- check Tables count & fields values BEFORE connect_trees' do
        describe '- check all profile_ids in ProfileKey rows ' do
          let(:profiles_ids_arr) {[2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 7, 7, 7, 7, 8, 8, 8, 8, 9, 9,
                                   9, 9, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
                                   11, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13,
                                   14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15,
                                   15, 15, 15, 15, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 17, 17, 17,
                                   17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 18, 18, 18, 18, 18, 19, 19, 19, 19, 19,
                                   20, 20, 20, 20, 20, 21, 21, 21, 21, 21, 22, 22, 22, 22, 22, 22, 22, 23, 23, 23, 23,
                                   23, 23, 23, 24, 24, 24, 24, 24, 24, 24, 25, 25, 25, 25, 25, 25, 25, 26, 26, 26, 26,
                                   26, 27, 27, 27, 27, 27, 28, 28, 28, 28, 28, 29, 29, 29, 29, 29, 124, 124, 124, 124]}
          let(:profiles_ids_arr_size) {196}
          it_behaves_like :successful_profile_keys_profile_ids
        end

        describe '- check ConnectionRequest BEFORE <connect_trees>'  do #, focus: true
          it '- check ConnectionRequest third row - Ok'  do # , focus: true
            connection_request_fields = ConnectionRequest.third.attributes.except('created_at','updated_at')
            expect(connection_request_fields).to eq({"id"=>3, "user_id"=>3, "with_user_id"=>1, "confirm"=>nil,
                                                     "done"=>false, "connection_id"=>3} )
          end
          it '- check ConnectionRequest last row - Ok' do # , focus: true
            connection_request_fields = ConnectionRequest.last.attributes.except('created_at','updated_at')
            expect(connection_request_fields).to eq({"id"=>4, "user_id"=>3, "with_user_id"=>2, "confirm"=>nil,
                                                     "done"=>false, "connection_id"=>3} )
          end
        end

        describe '- check UpdatesFeed BEFORE <connect_trees>'  do #, focus: true
          describe '- check UpdatesFeed rows count AFTER <connect_trees>' do
            let(:rows_qty) {0}
            it_behaves_like :successful_updates_feed_rows_count
          end
        end

      end


      ################ CONNECTION  ###########################


      context '- check Tables count & fields values when valid connection_data AFTER <connect_trees>'  do # , focus: true
        # profiles_to_rewrite = connection_data[:profiles_to_rewrite]
        # profiles_to_destroy = connection_data[:profiles_to_destroy]
        # who_connect         = connection_data[:who_connect]
        # with_whom_connect   = connection_data[:with_whom_connect]
        # current_user_id     = connection_data[:current_user_id]
        # user_id             = connection_data[:user_id]
        # connection_id       = connection_data[:connection_id]
        let(:connection_data) {{:who_connect_arr=>[1, 2], :with_whom_connect_arr=>[3],
                                :profiles_to_rewrite=>[14, 21, 19, 11, 20, 12, 13, 18],
                                :profiles_to_destroy=>[22, 29, 27, 25, 28, 23, 24, 26],
                                :current_user_id=>1, :user_id=>3, :connection_id=>3} }
        before { current_user_1.connection_in_tables(connection_data) }

        context '- check SearchResults model AFTER <connect_trees> module'  do #  ,  focus: true
          describe '- check SearchResults have rows count AFTER <connect_trees> - Ok' do
            let(:rows_qty) {1}
            it_behaves_like :successful_search_results_rows_count
          end
          it '- check SearchResults First Factory row - Ok' do # , focus: true
            search_results_fields = SearchResults.first.attributes.except('created_at','updated_at')
            expect(search_results_fields).to eq({"id"=>1, "user_id"=>15, "found_user_id"=>35, "profile_id"=>5,
                                                 "found_profile_id"=>7, "count"=>4, "found_profile_ids"=>[7, 25],
                                                 "searched_profile_ids"=>[5, 52], "counts"=>[4, 4],
                                                 "connection_id"=>nil, "pending_connect"=>0} )
          end
        end

        describe '- check Profiles AFTER <connect_trees>'   do #, focus: true
          let(:opposite_profiles_arr) {connection_data[:profiles_to_destroy]}
          let(:profiles_deleted) {[1,1,1,1,1,1,1,1]}
          it_behaves_like :successful_profiles_deleted_arr
        end

        describe '- check all profile_ids generated in ProfileKey rows AFTER <connect_trees>' do
          let(:profiles_ids_arr) {[2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 7, 7, 7, 7, 8, 8, 8, 8, 9, 9,
                                   9, 9, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
                                   11, 11, 11, 11, 11, 11, 11, 11, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12,
                                   12, 12, 12, 12, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13,
                                   14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 15, 15,
                                   15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16,
                                   16, 16, 16, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 18, 18, 18,
                                   18, 18, 18, 18, 18, 18, 18, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 20, 20, 20, 20,
                                   20, 20, 20, 20, 20, 20, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 124, 124, 124, 124]}
          let(:profiles_ids_arr_size) {196}
          it_behaves_like :successful_profile_keys_profile_ids
        end

        describe '- check ConnectionLog Profiles.deleted update count AFTER <connect_trees>'  do # , focus: true
          it '- check ConnectionLog have rows count - Ok' do
            profiles_del_logs_count =  ConnectionLog.where(field: 'deleted').count
            puts "in check ConnectionLog Profiles.deleted count: profiles_del_logs_count = #{profiles_del_logs_count.inspect} \n"
            # expect(connection_logs_count).to eq(rows_qty) # got rows_qty of ConnectionLog
          end
        end

        describe '- check ConnectionLog rows count AFTER <connect_trees>'  do # , focus: true
          let(:rows_qty) {122}
          it_behaves_like :successful_connection_logs_rows_count
        end

        describe '- check ConnectionLog fields AFTER <connect_trees>'  do # , focus: true
          let(:rewrite) {[14, 12, 13, 21, 19, 11, 20, 18]}
          let(:overwrite) {[22, 23, 24, 29, 27, 25, 28, 26]}
          let(:deleted) {[1,1,1,1,1,1,1,1]}
          it_behaves_like :successful_rewrite_arrays_logs_after_connect
        end

        context ' - check CommonLog table AFTER <connect_trees>' do
          describe '- check CommonLog have rows count - Ok ' do
            let(:rows_qty) {1}
            it_behaves_like :successful_common_logs_rows_count
          end
          it '- check CommonLog 1st & last row - Ok' do # , focus: true
            common_log_row_fields = CommonLog.last.attributes.except('created_at','updated_at')
            expect(common_log_row_fields).to eq({"id"=>1, "user_id"=>1, "log_type"=>4, "log_id"=>3, "profile_id"=>17,
                                                 "base_profile_id"=>14, "relation_id"=>999} )
          end
        end

        describe '- check ConnectedUsers AFTER <connect_trees>'  do #, focus: true
          let(:current_user_1) { User.first }  # User = 1. Tree = [1,2]. profile_id = 17
          let(:currentuser_id) {current_user_1.id}  # id = 1
          let(:connected_users) { current_user_1.get_connected_users }  # [1,2]

          context '- AFTER <connect_trees> - check connected_users' do
            it '- check ConnectedUser last row - Ok' do
              connect_trees_row_fields = ConnectedUser.last.attributes.except('created_at','updated_at')
              puts "Check ConnectedUser AFTER <connect_trees> \n"
              expect(connect_trees_row_fields).to eq({"id"=>10, "user_id"=>1, "with_user_id"=>3, "connected"=>false,
                                                   "connection_id"=>3,
                                                   "rewrite_profile_id"=>18, "overwrite_profile_id"=>26} )
            end
            it "- Return proper connected_users Array result for current_user_id = 1" do
              puts "AFTER <connect_trees> - check connected_users - connected_users created \n"
              expect(connected_users).to be_a_kind_of(Array)
            end
            it "- Return proper connected_users Array result for current_user_id = 1" do
              puts "connected_users = #{connected_users} \n"
              expect(connected_users).to eq([1,2,3])
            end
          end
        end


        describe '- check User.connected_users AFTER <connect_trees>'   do #, focus: true
          let(:connected_users_arr_1) {[1,2,3]}
          let(:connected_users_arr_2) {[1,2,3]}
          let(:connected_users_arr_3) {[1,2,3]}
          puts "Check AFTER <connect_trees>"
          it_behaves_like :successful_users_connected
        end


        describe '- check UpdatesFeed AFTER <connect_trees>' do #, focus: true
          describe '- check UpdatesFeed rows count AFTER <connect_trees>' do
            let(:rows_qty) {2}  # т.к.  - вне модели
            it_behaves_like :successful_updates_feed_rows_count
          end
          it '- check UpdatesFeed 1 row - Ok'  do # , focus: true
            connection_request_fields = UpdatesFeed.first.attributes.except('created_at','updated_at')
            expect(connection_request_fields).to eq({"id"=>1, "user_id"=>1, "update_id"=>2, "agent_user_id"=>3,
                                                     "read"=>false, "agent_profile_id"=>14, "who_made_event"=>1} )
          end
          it '- check UpdatesFeed 2 row - Ok' do # , focus: true
            connection_request_fields = UpdatesFeed.last.attributes.except('created_at','updated_at')
            expect(connection_request_fields).to eq({"id"=>2, "user_id"=>3, "update_id"=>2, "agent_user_id"=>1,
                                                     "read"=>false, "agent_profile_id"=>17, "who_made_event"=>1} )
          end
        end

      end

      describe '- check ConnectionRequest AFTER <connect_trees>'  do # , focus: true
        let(:connection_data) {{:who_connect_arr=>[1, 2], :with_whom_connect_arr=>[3],
                                :profiles_to_rewrite=>[14, 21, 19, 11, 20, 12, 13, 18],
                                :profiles_to_destroy=>[22, 29, 27, 25, 28, 23, 24, 26],
                                :current_user_id=>1, :user_id=>3, :connection_id=>3} }
        before {  # ConnectionRequest
                  FactoryGirl.create(:connection_request, :conn_request_3_4)    # id = 5  done: true
                  FactoryGirl.create(:connection_request, :conn_request_4_5)    # id = 6  done: true
                  FactoryGirl.create(:connection_request, :conn_request_4_1)    # id = 7  done: false
                  FactoryGirl.create(:connection_request, :conn_request_4_2)    # id = 8  done: false
                  FactoryGirl.create(:connection_request, :conn_request_1_8)    # id = 9  done: false
                  FactoryGirl.create(:connection_request, :conn_request_1_7)    # id = 10  done: false
                  FactoryGirl.create(:connection_request, :conn_request_5_1)    # id = 11  done: false
                  FactoryGirl.create(:connection_request, :conn_request_5_2)    # id = 12  done: false
                  FactoryGirl.create(:connection_request, :conn_request_10_5)   # id = 13  done: false

                  # ConnectedUser
                  FactoryGirl.create(:connected_user, :connected_3_4)    #
                  FactoryGirl.create(:connected_user, :connected_4_5)    #

                  current_user_1.connection_in_tables(connection_data)

          }

        let(:current_user_1) { User.first }  # User = 1. Tree = [1,2] - before connect with [3]. profile_id = 17
        let(:currentuser_id) {current_user_1.id}  # id = 1
        let(:connected_users_1) { current_user_1.get_connected_users }

        let(:user_2_connected) { User.second }  # User = 2. Tree = [1,2]. profile_id = 11
        let(:connected_users_2) { user_2_connected.get_connected_users }

        let(:user_3_connected) { User.third }  # User = 3. Tree = [3,4,5]. profile_id = 22
        let(:connected_users_3) { user_3_connected.get_connected_users }

        let(:user_4_connected) { User.find(4) }  # User = 4. Tree = [3,4,5]. profile_id = 53
        let(:connected_users_4) { user_4_connected.get_connected_users }

        let(:user_5_connected) { User.find(5) }  # User = 5  Tree = [3,4,5]. profile_id = 63
        let(:connected_users_5) { user_5_connected.get_connected_users }

        context '- AFTER <connect_tree> - check ConnectedUser' do
          puts "Check ConnectedUser AFTER <connect_tree>"
          it "- Return proper connected_users Array result for current_user_id = 1" do
            puts "connected_users_1 = #{connected_users_1} \n"
            expect(connected_users_1).to eq([1,2,3,4,5])
          end
          it "- Return proper connected_users Array result for current_user_id = 2" do
            puts "connected_users_2 = #{connected_users_2} \n"
            expect(connected_users_2).to eq([1,2,3,4,5])
          end
          it "- Return proper connected_users Array result for current_user_id = 1" do
            puts "connected_users_3 = #{connected_users_3} \n"
            expect(connected_users_3).to eq([1,2,3,4,5])
          end
          it "- Return proper connected_users Array result for current_user_id = 1" do
            puts "connected_users_4 = #{connected_users_4} \n"
            expect(connected_users_4).to eq([1,2,3,4,5])
          end
          it "- Return proper connected_users Array result for current_user_id = 1" do
            puts "connected_users_5 = #{connected_users_5} \n"
            expect(connected_users_5).to eq([1,2,3,4,5])
          end
        end

        describe '- AFTER <connect_tree>  check request_connection have rows count - Ok ' do
          puts "Check ConnectionRequest AFTER <connect_tree>"
          let(:rows_qty) {13}
          it_behaves_like :successful_connection_request_rows_count
        end

        describe '- check ConnectionRequest third row - Ok ' do
          let(:request_id) {3}
          let(:updated_request) {{"id"=>3, "user_id"=>3, "with_user_id"=>1, "confirm"=>1,
                                  "done"=>true, "connection_id"=>3}}
          it_behaves_like :successful_connection_request_update
        end
        describe '- check ConnectionRequest forth row - Ok ' do
          let(:request_id) {4}
          let(:updated_request) {{"id"=>4, "user_id"=>3, "with_user_id"=>2, "confirm"=>nil,
                                  "done"=>true, "connection_id"=>3}}
          it_behaves_like :successful_connection_request_update
        end

        describe '- AFTER <connect_tree>  check connected_requests_update - Ok '    do  # , focus: true

          describe '- check ConnectionRequest 5 row - Ok ' do
            let(:request_id) {5}
            let(:updated_request) {{"id"=>5, "user_id"=>3, "with_user_id"=>4, "confirm"=>1,
                                    "done"=>true, "connection_id"=>4}}
            it_behaves_like :successful_connection_request_update
          end
          describe '- check ConnectionRequest 6 row - Ok ' do
            let(:request_id) {6}
            let(:updated_request) {{"id"=>6, "user_id"=>4, "with_user_id"=>5, "confirm"=>1,
                                    "done"=>true, "connection_id"=>5}}
            it_behaves_like :successful_connection_request_update
          end
          describe '- check ConnectionRequest 7 row - Ok ' do
            let(:request_id) {7}
            let(:updated_request) {{"id"=>7, "user_id"=>4, "with_user_id"=>1, "confirm"=>2,
                                    "done"=>true, "connection_id"=>6}}
            it_behaves_like :successful_connection_request_update
          end
          describe '- check ConnectionRequest 8 row - Ok ' do
            let(:request_id) {8}
            let(:updated_request) {{"id"=>8, "user_id"=>4, "with_user_id"=>2, "confirm"=>2,
                                    "done"=>true, "connection_id"=>6}}
            it_behaves_like :successful_connection_request_update
          end
          describe '- check ConnectionRequest 9 row - Ok ' do
            let(:request_id) {9}
            let(:updated_request) {{"id"=>9, "user_id"=>1, "with_user_id"=>8, "confirm"=>nil,
                                    "done"=>false, "connection_id"=>7}}
            it_behaves_like :successful_connection_request_update
          end
          describe '- check ConnectionRequest 10 row - Ok ' do
            let(:request_id) {10}
            let(:updated_request) {{"id"=>10, "user_id"=>1, "with_user_id"=>7, "confirm"=>nil,
                                    "done"=>false, "connection_id"=>7} }
            it_behaves_like :successful_connection_request_update
          end
          describe '- check ConnectionRequest 11 row - Ok ' do
            let(:request_id) {11}
            let(:updated_request) {{"id"=>11, "user_id"=>5, "with_user_id"=>1, "confirm"=>2,
                                    "done"=>true, "connection_id"=>8}}
            it_behaves_like :successful_connection_request_update
          end
          describe '- check ConnectionRequest 12 row - Ok ' do
            let(:request_id) {12}
            let(:updated_request) {{"id"=>12, "user_id"=>5, "with_user_id"=>2, "confirm"=>2,
                                    "done"=>true, "connection_id"=>8}}
            it_behaves_like :successful_connection_request_update
          end
          describe '- check ConnectionRequest 13 row - Ok ' do
            let(:request_id) {13}
            let(:updated_request) {{"id"=>13, "user_id"=>10, "with_user_id"=>5, "confirm"=>nil,
                                    "done"=>false, "connection_id"=>9}}
            it_behaves_like :successful_connection_request_update
          end

        end

      end

    end

    ################  DISCONNECTION ###########################

    describe '- check User model Method <disconnect> - Ok'  do  #  , focus: true

      context '- check Tables count & fields values when valid disconnection_data'  do #, focus: true
        let(:connection_data) {{:who_connect_arr=>[1, 2], :with_whom_connect_arr=>[3],
                                :profiles_to_rewrite=>[14, 21, 19, 11, 20, 12, 13, 18],
                                :profiles_to_destroy=>[22, 29, 27, 25, 28, 23, 24, 26],
                                :current_user_id=>1, :user_id=>3, :connection_id=>3} }
        let(:common_log_id) { 1 }
        let(:user_2_connected) { User.second }  # User = 2. Tree = [1,2]. profile_id = 11
        # let(:connected_users_2) { user_2_connected.get_connected_users }
        before {
          current_user_1.connection_in_tables(connection_data)  ############
          # connected_users_1 = current_user_1.get_connected_users   # [1,2]
          # connection_req_count = ConnectionRequest.all.count
          # com_log = CommonLog.first.attributes.except('created_at','updated_at')
          # puts " connection_req_count = #{connection_req_count} \n"
          # connection_log_count = ConnectionLog.all.count
          # user_3_profile = User.find(3).profile_id
          # puts "Before Disconnect:\n user_3_profile = #{user_3_profile}, Common_log count = #{common_log_count}
          #          Connection_log count = #{connection_log_count} \n
          #        connected_users_1 = #{connected_users_1} "  # 1     114

          # current_user_1.disconnect_tree(common_log_id)
          user_2_connected.disconnect_tree(common_log_id)

          # connected_users_1_disconn = current_user_1.get_connected_users   # [1,2]
          # puts "After Disconnect: connected_users_1_disconn = #{connected_users_1_disconn} "  # 1
          ############
        }

        describe '- check ConnectedUsers AFTER <disconnect_tree>'  do #, focus: true
          let(:current_user_1) { User.first }  # User = 1. Tree = [1,2]. profile_id = 17
          let(:currentuser_id) {current_user_1.id}  # id = 1
          let(:connected_users) { current_user_1.get_connected_users }  # [1,2]

          context '- AFTER <disconnect_tree> - check connected_users' do
            puts "Check Disconnect"
            it "- Return proper connected_users Array result for current_user_id = 1" do
              puts "AFTER <disconnect_tree> - check connected_users - connected_users created \n"
              expect(connected_users).to be_a_kind_of(Array)
            end
            it "- Return proper connected_users Array result for current_user_id = 1" do
              puts "connected_users = #{connected_users} \n"
              expect(connected_users).to eq([1,2])
            end
          end
        end

        describe '- check User.connected_users AFTER <disconnect_tree>'   do #, focus: true
          let(:connected_users_arr_1) {[1,2]}
          let(:connected_users_arr_2) {[1,2]}
          let(:connected_users_arr_3) {[3]}   ############ [3]!
          puts "Check AFTER <disconnect_tree>"
          it_behaves_like :successful_users_connected
        end


        describe '- check UpdatesFeed AFTER <disconnect_tree>'  do #, focus: true
          describe '- check UpdatesFeed rows count AFTER <connect_trees>' do
            let(:rows_qty) {4}  # т.к.  - вне модели
            it_behaves_like :successful_updates_feed_rows_count
          end
          it '- check UpdatesFeed 1 row - Ok'  do # , focus: true
            connection_request_fields = UpdatesFeed.find(1).attributes.except('created_at','updated_at')
            expect(connection_request_fields).to eq({"id"=>1, "user_id"=>1, "update_id"=>2, "agent_user_id"=>3,
                                                     "read"=>false, "agent_profile_id"=>14, "who_made_event"=>1} )
          end
          it '- check UpdatesFeed 2 row - Ok' do # , focus: true
            connection_request_fields = UpdatesFeed.find(2).attributes.except('created_at','updated_at')
            expect(connection_request_fields).to eq({"id"=>2, "user_id"=>3, "update_id"=>2, "agent_user_id"=>1,
                                                     "read"=>false, "agent_profile_id"=>17, "who_made_event"=>1} )
          end
          it '- check UpdatesFeed 3 row - Ok'  do # , focus: true
            connection_request_fields = UpdatesFeed.find(3).attributes.except('created_at','updated_at')
            expect(connection_request_fields).to eq({"id"=>3, "user_id"=>2, "update_id"=>17, "agent_user_id"=>3,
                                                     "read"=>false, "agent_profile_id"=>22, "who_made_event"=>2} )
          end
          it '- check UpdatesFeed 4 row - Ok' do # , focus: true
            connection_request_fields = UpdatesFeed.find(4).attributes.except('created_at','updated_at')
            expect(connection_request_fields).to eq( {"id"=>4, "user_id"=>3, "update_id"=>17, "agent_user_id"=>2,
                                                      "read"=>false, "agent_profile_id"=>11, "who_made_event"=>2}
                                                 )
          end
          # it '- check UpdatesFeed 5 row - Ok' do # , focus: true
          #   connection_request_fields = UpdatesFeed.find(5).attributes.except('created_at','updated_at')
          #   expect(connection_request_fields).to eq( {"id"=>5, "user_id"=>3, "update_id"=>17, "agent_user_id"=>2,
          #                                             "read"=>false, "agent_profile_id"=>11, "who_made_event"=>2}
          #                                        )
          # end
        end


        describe '- check all profile_ids generated in ProfileKey rows AFTER <disconnect_tree>' do
          let(:profiles_ids_arr) {[2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 7, 7, 7, 7, 8, 8, 8, 8, 9, 9,
                                   9, 9, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
                                   11, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13,
                                   14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15,
                                   15, 15, 15, 15, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 17, 17, 17,
                                   17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 18, 18, 18, 18, 18, 19, 19, 19, 19, 19,
                                   20, 20, 20, 20, 20, 21, 21, 21, 21, 21, 22, 22, 22, 22, 22, 22, 22, 23, 23, 23, 23,
                                   23, 23, 23, 24, 24, 24, 24, 24, 24, 24, 25, 25, 25, 25, 25, 25, 25, 26, 26, 26, 26,
                                   26, 27, 27, 27, 27, 27, 28, 28, 28, 28, 28, 29, 29, 29, 29, 29, 124, 124, 124, 124]}
          let(:profiles_ids_arr_size) {196}
          it_behaves_like :successful_profile_keys_profile_ids
        end

        describe '- check ConnectionLog rows count AFTER <disconnect_tree>' do
          let(:rows_qty) {0}
          it_behaves_like :successful_connection_logs_rows_count
        end

        # Проверка deleted у Profiles AFTER <disconnect_tree>
        describe '- check Profiles deleted AFTER <disconnect_tree>'   do #, focus: true
          let(:opposite_profiles_arr) {connection_data[:profiles_to_destroy]}
          let(:profiles_deleted) {[0,0,0,0,0,0,0,0]}
          it_behaves_like :successful_profiles_deleted_arr
        end

        describe '- check CommonLog have rows count AFTER <disconnect_tree>' do
          let(:rows_qty) {0}
          it_behaves_like :successful_common_logs_rows_count
        end
      end

      describe '- check ConnectionRequest AFTER <disconnect_tree>' do #, focus: true

        # puts "Check request_disconnection AFTER <disconnect_tree>"
        describe '- check ConnectionRequest have rows count - Ok ' do
          let(:rows_qty) {4}
          it_behaves_like :successful_connection_request_rows_count
        end
        describe '- check ConnectionRequest - rollback third row - Ok ' do
          let(:request_id) {3}
          let(:updated_request) {{"id"=>3, "user_id"=>3, "with_user_id"=>1, "confirm"=>nil,
                                  "done"=>false, "connection_id"=>3}}
          it_behaves_like :successful_connection_request_update
        end
        describe '- check ConnectionRequest - rollback forth row - Ok ' do
          let(:request_id) {4}
          let(:updated_request) {{"id"=>4, "user_id"=>3, "with_user_id"=>2, "confirm"=>nil,
                                  "done"=>false, "connection_id"=>3}}
          it_behaves_like :successful_connection_request_update
        end
        puts "Connection Requests - rolled back AFTER <disconnect_tree>"
      end

      describe '- check ConnectionRequest AFTER <disconnect_tree>'   do # , focus: true
        let(:connection_data) {{:who_connect_arr=>[1, 2], :with_whom_connect_arr=>[3],
                                :profiles_to_rewrite=>[14, 21, 19, 11, 20, 12, 13, 18],
                                :profiles_to_destroy=>[22, 29, 27, 25, 28, 23, 24, 26],
                                :current_user_id=>1, :user_id=>3, :connection_id=>3} }
        let(:common_log_id) { 1 }

        before {  # ConnectionRequest
          FactoryGirl.create(:connection_request, :conn_request_3_4)    # id = 5  done: true
          FactoryGirl.create(:connection_request, :conn_request_4_5)    # id = 6  done: true
          FactoryGirl.create(:connection_request, :conn_request_4_1)    # id = 7  done: false
          FactoryGirl.create(:connection_request, :conn_request_4_2)    # id = 8  done: false
          FactoryGirl.create(:connection_request, :conn_request_1_8)    # id = 9  done: false
          FactoryGirl.create(:connection_request, :conn_request_1_7)    # id = 10  done: false
          FactoryGirl.create(:connection_request, :conn_request_5_1)    # id = 11  done: false
          FactoryGirl.create(:connection_request, :conn_request_5_2)    # id = 12  done: false
          FactoryGirl.create(:connection_request, :conn_request_10_5)   # id = 13  done: false

          # ConnectedUser
          FactoryGirl.create(:connected_user, :connected_3_4)    #
          FactoryGirl.create(:connected_user, :connected_4_5)    #

          current_user_1.connection_in_tables(connection_data)
          current_user_1.disconnect_tree(common_log_id)

        }

        let(:current_user_1) { User.first }  # User = 1. Tree = [1,2] - before connect with [3]. profile_id = 17
        let(:currentuser_id) {current_user_1.id}  # id = 1
        let(:connected_users_1) { current_user_1.get_connected_users }

        let(:user_2_connected) { User.second }  # User = 2. Tree = [1,2]. profile_id = 11
        let(:connected_users_2) { user_2_connected.get_connected_users }

        let(:user_3_connected) { User.third }  # User = 3. Tree = [3,4,5]. profile_id = 22
        let(:connected_users_3) { user_3_connected.get_connected_users }

        let(:user_4_connected) { User.find(4) }  # User = 4. Tree = [3,4,5]. profile_id = 53
        let(:connected_users_4) { user_4_connected.get_connected_users }

        let(:user_5_connected) { User.find(5) }  # User = 5  Tree = [3,4,5]. profile_id = 63
        let(:connected_users_5) { user_5_connected.get_connected_users }

        context '- AFTER <disconnect_tree> - check ConnectedUser' do
          puts "Check ConnectedUser AFTER <disconnect_tree>"
          it "- Return proper connected_users Array result for current_user_id = 1" do
            puts "connected_users_1 = #{connected_users_1} \n"
            expect(connected_users_1).to eq([1,2])
          end
          it "- Return proper connected_users Array result for current_user_id = 2" do
            puts "connected_users_2 = #{connected_users_2} \n"
            expect(connected_users_2).to eq([1,2])
          end
          it "- Return proper connected_users Array result for current_user_id = 1" do
            puts "connected_users_3 = #{connected_users_3} \n"
            expect(connected_users_3).to eq([3,4,5])
          end
          it "- Return proper connected_users Array result for current_user_id = 1" do
            puts "connected_users_4 = #{connected_users_4} \n"
            expect(connected_users_4).to eq([3,4,5])
          end
          it "- Return proper connected_users Array result for current_user_id = 1" do
            puts "connected_users_5 = #{connected_users_5} \n"
            expect(connected_users_5).to eq([3,4,5])
          end
        end

        describe '- AFTER <disconnect_tree>  check request_connection have rows count - Ok '  do # , focus: true
          puts "Check ConnectionRequest AFTER <disconnect_tree>"
          let(:rows_qty) {13}
          it_behaves_like :successful_connection_request_rows_count
        end

        describe '- check ConnectionRequest third row - Ok ' do
          let(:request_id) {3}
          let(:updated_request) {{"id"=>3, "user_id"=>3, "with_user_id"=>1, "confirm"=>1,
                                  "done"=>true, "connection_id"=>3}}
          it_behaves_like :successful_connection_request_update
        end
        describe '- check ConnectionRequest forth row - Ok ' do
          let(:request_id) {4}
          let(:updated_request) {{"id"=>4, "user_id"=>3, "with_user_id"=>2, "confirm"=>nil,
                                  "done"=>true, "connection_id"=>3}}
          it_behaves_like :successful_connection_request_update
        end

        describe '- AFTER <disconnect_tree>  check connected_requests_update - Ok '    do  # , focus: true

          describe '- check ConnectionRequest 5 row - Ok ' do
            let(:request_id) {5}
            let(:updated_request) {{"id"=>5, "user_id"=>3, "with_user_id"=>4, "confirm"=>1,
                                    "done"=>true, "connection_id"=>4}}
            it_behaves_like :successful_connection_request_update
          end
          describe '- check ConnectionRequest 6 row - Ok ' do
            let(:request_id) {6}
            let(:updated_request) {{"id"=>6, "user_id"=>4, "with_user_id"=>5, "confirm"=>1,
                                    "done"=>true, "connection_id"=>5}}
            it_behaves_like :successful_connection_request_update
          end
          describe '- check ConnectionRequest 7 row - Ok ' do
            let(:request_id) {7}
            let(:updated_request) {{"id"=>7, "user_id"=>4, "with_user_id"=>1, "confirm"=>2,
                                    "done"=>true, "connection_id"=>6}}
            it_behaves_like :successful_connection_request_update
          end
          describe '- check ConnectionRequest 8 row - Ok ' do
            let(:request_id) {8}
            let(:updated_request) {{"id"=>8, "user_id"=>4, "with_user_id"=>2, "confirm"=>2,
                                    "done"=>true, "connection_id"=>6}}
            it_behaves_like :successful_connection_request_update
          end
          describe '- check ConnectionRequest 9 row - Ok ' do
            let(:request_id) {9}
            let(:updated_request) {{"id"=>9, "user_id"=>1, "with_user_id"=>8, "confirm"=>nil,
                                    "done"=>false, "connection_id"=>7}}
            it_behaves_like :successful_connection_request_update
          end
          describe '- check ConnectionRequest 10 row - Ok ' do
            let(:request_id) {10}
            let(:updated_request) {{"id"=>10, "user_id"=>1, "with_user_id"=>7, "confirm"=>nil,
                                    "done"=>false, "connection_id"=>7} }
            it_behaves_like :successful_connection_request_update
          end
          describe '- check ConnectionRequest 11 row - Ok ' do
            let(:request_id) {11}
            let(:updated_request) {{"id"=>11, "user_id"=>5, "with_user_id"=>1, "confirm"=>2,
                                    "done"=>true, "connection_id"=>8}}
            it_behaves_like :successful_connection_request_update
          end
          describe '- check ConnectionRequest 12 row - Ok ' do
            let(:request_id) {12}
            let(:updated_request) {{"id"=>12, "user_id"=>5, "with_user_id"=>2, "confirm"=>2,
                                    "done"=>true, "connection_id"=>8}}
            it_behaves_like :successful_connection_request_update
          end
          describe '- check ConnectionRequest 13 row - Ok ' do
            let(:request_id) {13}
            let(:updated_request) {{"id"=>13, "user_id"=>10, "with_user_id"=>5, "confirm"=>nil,
                                    "done"=>false, "connection_id"=>9}}
            it_behaves_like :successful_connection_request_update
          end

        end

      end







    end

  end

end
