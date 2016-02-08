require 'rails_helper'

RSpec.describe Profile, :type => :model   do # , focus: true

  describe 'Validation test Before Model Profile methods '    do # , focus: true
    after {
      Profile.delete_all
      Profile.reset_pk_sequence
    }

    it "has a valid factory" do
      puts " Model Profile validation - has a valid factory"
      expect(FactoryGirl.create(:test_model_profile)).to be_valid
    end

    it "is invalid without a name_id" do
      puts " Model Profile validation - invalid without a name_id"
      expect(FactoryGirl.build(:test_model_profile, name_id: nil)).to_not be_valid
    end

    it "is invalid without a tree_id" do
      puts " Model Profile validation - invalid without a tree_id"
      expect(FactoryGirl.build(:test_model_profile, tree_id: nil)).to_not be_valid
    end

    # todo: test association in Model
    context "test for correct values pair: name_id.sex_id & profile.sex_id " do
      # let(:row_name) {FactoryGirl.create(:test_model_name)}
      let(:row_profile) {FactoryGirl.create(:test_model_profile)}
      it "is invalid with name_id.sex_id == 1 and profile.sex_id == 0" do
        # puts " Model Name validation - name.id = #{row_name.id}"
        # puts " Model Name validation - name.name = #{row_name.name}"

        # puts " Model Profile validation - invalid with name_id.sex_id == 1 and profile.sex_id == 0"
        # puts " Model Profile validation - profile.user_id = #{row.row}"
        puts " Model Profile validation - profile.user_id = #{row_profile.user_id}"
        puts " Model Profile validation - profile.name_id = #{row_profile.name_id}"
        puts " Model Profile validation - profile.sex_id = #{row_profile.sex_id}"
        # puts " Model Profile validation - profile.deleted = #{row_profile.deleted}"
        # puts " Model Profile validation - profile.tree_id = #{row_profile.tree_id}"
      end
    end

  end


  describe 'Method Rename Profile test'   do # , focus: true

    context "- Check Method Rename Profile random created  -"   do  # , focus: true
      before {     # Name
        FactoryGirl.create(:name, :name_150)   # 150  Демьян
      }
      let(:row_profile) {FactoryGirl.create(:test_model_profile)}
      let(:profile_id) {row_profile.id}
      let(:new_name_id) {150}

      describe '- check Name have name 150 - Ok' do
        it "- Have correct Name 150 - Ok " do

        name_150_fields = Name.find(150).attributes.except('created_at','updated_at')
        expect(name_150_fields).to eq({"id"=>150, "name"=>"Демьян", "only_male"=>nil, "name_freq"=>0,
                                       "is_approved"=>false, "sex_id"=>1, "parent_name_id"=>nil,
                                       "search_name_id"=>150})
        end
      end

      it "- profile Renamed - Ok " do
        p " Check Method Rename Profile random created"
        p " Check Before: row_profile.id = #{row_profile.id}, row_profile.sex_id = #{row_profile.sex_id}, row_profile.name_id = #{row_profile.name_id}"
        row_profile.rename(new_name_id)#.attributes.except('created_at','updated_at', 'sex_id')
        puts " Model Profile: After rename - new_name_id = #{Profile.find(row_profile.id).name_id}"
        expect(Profile.find(row_profile.id).name_id).to eq(150)
      end

      context "- Check Before Method Rename in Tree & ProfileKey - No Renames "    do  #
        describe '- check Tree have rows count before - Ok' do
          let(:rows_qty) {0}
          it_behaves_like :successful_tree_rows_count
        end

        describe '- check ProfileKey have rows count before - Ok' do
          let(:rows_qty) {0}
          it_behaves_like :successful_profile_keys_rows_count
        end
      end

    end

    context "- Check Method Rename Profile for Models content created  -"    do  #

      before {
        # Name
        FactoryGirl.create(:name, :name_150)   # 150  Демьян

        # Profile, 85 - name_id = 370.
        FactoryGirl.create(:add_profile, :add_profile_85)   # 85

        # Tree, 85 - name_id = 370.
        FactoryGirl.create(:tree, :add_tree9_1)   # 85 - 86, is_name_id = 28
        FactoryGirl.create(:tree, :add_tree9_2)   # 85 - 87, is_name_id = 48
        FactoryGirl.create(:tree, :add_tree9_3)   # 85 - 88, is_name_id = 465
        FactoryGirl.create(:tree, :add_tree9_4)   # 85 - 89, is_name_id = 345
        FactoryGirl.create(:tree, :add_tree9_5)   # 85 - 90, is_name_id = 343
        FactoryGirl.create(:tree, :add_tree9_6)   # 85 - 91, is_name_id = 446
        FactoryGirl.create(:tree, :add_tree9_7)   # 85 - 92, is_name_id = 147
        # Tree, 92 - name_id = 147.
        FactoryGirl.create(:tree, :add_tree9_8)   # 92 - 85, is_name_id = 370

        # ProfileKey
        FactoryGirl.create(:profile_key, :profile_key9_add_1) # 85 - 86, name_id = 370, is_name_id = 28
        FactoryGirl.create(:profile_key, :profile_key9_add_2) # 86 - 85, name_id = 28,  is_name_id = 370

        FactoryGirl.create(:profile_key, :profile_key9_add_3) # 85 - 87, name_id = 370, is_name_id = 48
        FactoryGirl.create(:profile_key, :profile_key9_add_4) # 87 - 85, name_id = 48,  is_name_id = 370

        FactoryGirl.create(:profile_key, :profile_key9_add_5) # 86 - 87, name_id = 28,  is_name_id = 48
        FactoryGirl.create(:profile_key, :profile_key9_add_6) # 87 - 86, name_id = 48,  is_name_id = 28

        FactoryGirl.create(:profile_key, :profile_key9_add_7) # 85 - 88, name_id = 370, is_name_id = 465
        FactoryGirl.create(:profile_key, :profile_key9_add_8) # 88 - 85, name_id = 465, is_name_id = 370

        FactoryGirl.create(:profile_key, :profile_key9_add_9)  # 86 - 88, name_id = 28, is_name_id = 465
        FactoryGirl.create(:profile_key, :profile_key9_add_10) # 88 - 86, name_id = 465, is_name_id = 28

        FactoryGirl.create(:profile_key, :profile_key9_add_11) # 87 - 88, name_id = 48, is_name_id = 465
        FactoryGirl.create(:profile_key, :profile_key9_add_12) # 88 - 87, name_id = 465, is_name_id = 48

        FactoryGirl.create(:profile_key, :profile_key9_add_13) # 85 - 89, name_id = 370, is_name_id = 345
        FactoryGirl.create(:profile_key, :profile_key9_add_14) # 89 - 85, name_id = 345, is_name_id = 370

        FactoryGirl.create(:profile_key, :profile_key9_add_15) # 86 - 89, name_id = 28, is_name_id = 345
        FactoryGirl.create(:profile_key, :profile_key9_add_16) # 89 - 86, name_id = 345, is_name_id = 28
      }

      after {
        Profile.delete_all
        Profile.reset_pk_sequence

        Tree.delete_all
        Tree.reset_pk_sequence

        ProfileKey.delete_all
        ProfileKey.reset_pk_sequence
      }


      context "- Before check Method Rename -"   do  # , focus: true
        let(:profile_id) {85}
        let(:new_name_id) {150}
        describe '- check Profile have rows count before profile.rename - Ok' do
          let(:rows_qty) {1}
          let(:rows_ids_arr) {[85]}
          it_behaves_like :successful_profiles_count_and_ids
        end
        describe '- check Tree have rows count before profile.rename - Ok' do
          let(:rows_qty) {8}
          it_behaves_like :successful_tree_rows_count
        end
        describe '- check Tree have name_ids array before profile.rename - Ok' do
          let(:array_of_name_ids) {[370, 370, 370, 370, 370, 370, 370]}
          it_behaves_like :successful_tree_name_ids_arr
        end

        describe '- check ProfileKey have rows count before profile.rename - Ok' do
          let(:rows_qty) {16}
          it_behaves_like :successful_profile_keys_rows_count
        end
        describe '- check ProfileKey have name_ids array before profile.rename - Ok' do
          let(:array_of_ids) {[1, 3, 7, 13]}
          let(:array_of_name_ids) {[370, 370, 370, 370]}
          it_behaves_like :successful_profile_keys_name_ids_arr
        end
      end

      context "- After check Method Rename -"    do  # , focus: true

        let(:profile_id) {85}
        let(:row_profile) {Profile.find(profile_id)}
        let(:new_name_id) {150}
        before { row_profile.rename(new_name_id) }

        it "- profile Renamed - Ok " do
          p "Check After Rename Profile for Models content created "
          p "After Profile rename; row_profile.id = #{row_profile.id}, row_profile.name_id = #{row_profile.name_id}"
          puts  " Model Profile: after rename - new_name_id = #{Profile.find(row_profile.id).name_id}"
          expect(Profile.find(row_profile.id).name_id).to eq(150)
        end

        describe '- check ProfileKey have name_ids array After profile.rename - Ok' do
          let(:array_of_ids) {[1, 3, 7, 13]}
          let(:array_of_name_ids) {[150, 150, 150, 150]}
          it_behaves_like :successful_profile_keys_name_ids_arr
        end
        describe '- check ProfileKey have is_name_ids array After profile.rename - Ok' do
          let(:array_of_is_name_ids) {[150, 150, 150, 150]}
          it_behaves_like :successful_profile_keys_is_name_ids_arr
        end

        describe '- check Tree have name_ids array After rename_in_tree  - Ok' do
          let(:array_of_name_ids) {[150, 150, 150, 150, 150, 150, 150]}
          it_behaves_like :successful_tree_name_ids_arr
        end
        describe '- check Tree have is_name_ids array After rename_in_tree  - Ok' do
          let(:array_of_is_name_ids) {[150]}
          it_behaves_like :successful_tree_is_name_ids_arr
        end

      end

    end

  end



  # describe 'Method Rename Profile test'   do # , focus: true
  #   after {
  #     Profile.delete_all
  #     Profile.reset_pk_sequence
  #   }
  #   let(:row_profile) {FactoryGirl.create(:test_model_profile)}
  #   let(:profile_id) {row_profile.id}
  #   let(:new_name_id) {150}
  #
  #   it "- profile Renamed - Ok " do
  #     p " Model Profile: before rename - row_profile.name_id = #{row_profile.name_id}"
  #     Profile.rename_in_profile(profile_id, new_name_id)#.attributes.except('created_at','updated_at', 'sex_id')
  #     puts  " Model Profil: after rename - new_name_id = #{Profile.find(row_profile.id).name_id}"
  #     expect(Profile.find(row_profile.id).name_id).to eq(150)
  #   end
  #
  # end


    describe '- validation'     do
    describe '- on create' do
      context '- valid profiles' do
        let(:first_profile) {FactoryGirl.create(:profile_one)}
        it '- 1 saves a valid profile_one' do

          puts " Model Profile validation "
          expect(first_profile).to be_valid
          profile_fields = Profile.first.attributes.except('created_at','updated_at', 'sex_id', 'display_name_id')
          expect(profile_fields).to eq({"id"=>1, "user_id"=>1, "name_id"=>354,
                                        "tree_id"=>5, "deleted"=>0} )
        end

        let(:second_profile) {FactoryGirl.create(:profile_two)}
        it '- 2 saves a valid profile_two' do
          expect(second_profile).to be_valid
        end

        let(:first_profile_2) {FactoryGirl.build(:profile_three)}
        it '- 3 saves a valid profile_three' do
          expect(first_profile_2).to be_valid
        end

        let(:second_profile_2) {FactoryGirl.build(:profile_four)}
        it '- 4 saves a valid profile_four' do
          expect(second_profile_2).to be_valid
        end

        let(:good_profile_row_big) {FactoryGirl.build(:profile_one, :big_IDs)}
        it '- 5 Saves a valid profile_row - big IDs' do
          expect(good_profile_row_big).to be_valid
        end

        let(:good_profile_row_no_user_id) {FactoryGirl.build(:profile_one, :without_user_id)}
        it '- 5 Saves a valid profile_row - no_user_id' do
          expect(good_profile_row_no_user_id).to be_valid
        end

      end
      before {
        #Name - for profile = 85
        FactoryGirl.create(:name, :name_370)   # Петр
      }

      let(:base_profile_85) { create(:add_profile, :add_profile_85) }  # User = 9. Tree = 9. profile_id = 85

      context '- check profile creation' do
        it 'creation profile - Ok' do
          puts "before All in Profile valid-s: Name.first.name = #{Name.first.name} \n"  # Петр
          puts "before All: base_profile_85.id = #{base_profile_85.id} \n"  # id = 85
          expect(base_profile_85).to be_valid
        end
      end
    end
  end

  describe '- Model methods'   do
    describe '- #' do
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
          expect(common_log_forth.profile_id).to eq(173)
          expect(common_log_forth.id).to eq(4)
        end
        describe '- check all relations generated in ProfileKey rows: start state - Ok'  do  # , focus: true
          let(:relations_ids_arr_all) {[1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 5, 5, 7, 7, 7, 8, 8, 8, 13, 13,
                                        14, 14, 17, 17, 17, 17, 91, 91, 91, 101, 101, 101, 111, 111, 111, 111, 121,
                                        121, 191, 221]}
          let(:relations_arr_all_size) {46}
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

      context '- After actions - create profile ' do

      end


      describe 'Method Profile profile_circle test' , focus: true  do # , focus: true
        context "- Check Method profile_circle for one Profile -"   do  # , focus: true
          let(:connected_users_arr) {[9]}
          let(:one_profile) { Profile.find(85) }
          let(:circle_array) { one_profile.profile_circle(connected_users_arr) }
          it '- check one profile exists - Ok' do
            puts "before profile_circle: one_profile.id = #{one_profile.id.inspect} \n"
            expect(one_profile.id).to eq(85)
          end
          it '- check one profile Circle array size - Ok' do
            puts "in profile_circle: circle_array = #{circle_array.inspect} \n"
            expect(circle_array.size).to eq(7)
          end
          it '- check one profile Circle: array of <is_profile_ids> - Ok' do
            is_profiles_ids = []
            circle_array.map { |one_record| is_profiles_ids << one_record.is_profile_id }
            is_profiles_ids.uniq
            puts "in profile_circle: is_profiles_ids = #{is_profiles_ids.inspect} \n"
            expect(is_profiles_ids).to eq([86, 87, 91, 88, 92, 172, 173])
          end
        end
      end



    end
  end



end
