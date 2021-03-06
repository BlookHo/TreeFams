describe ProfilesController, :type => :controller    do  # , focus: true  #, similars: true

  before {

    User.delete_all
    User.reset_pk_sequence

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
    FactoryGirl.create(:user, :user_9 )  # User = 9 . Tree = 9 . profile_id = 85
    # FactoryGirl.create(:user, :user_10 )  # User = 10. Tree = 10. profile_id = 93

    allow(controller).to receive(:logged_in?)
    allow(controller).to receive(:current_user).and_return current_user



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
    Name.delete_all
    Name.reset_pk_sequence
    CommonLog.delete_all
    CommonLog.reset_pk_sequence
    DeletionLog.delete_all
    DeletionLog.reset_pk_sequence
  }

  describe 'CHECK ProfilesController methods'   do # , focus: true

    describe 'GET #create'  do # , focus: true

      let(:current_user) { User.find(9) }   # User = 9. Tree = 1. profile_id = 85
      let(:currentuser_id) {current_user.id}

      let(:base_profile_id) {92}
      let(:profile_name_id) {465}
      let(:profile_params) {{relation_id: 5}}

      context '- before action <create> - check ' do

        describe '- check User have rows count before - Ok' do
          let(:rows_qty) {9}
          it_behaves_like :successful_users_rows_count
        end
        describe '- check Profiles have rows count before - Ok' do
          let(:rows_qty) {10}
          let(:rows_ids_arr) {[85, 86, 87, 88, 89, 90, 91, 92, 172, 173]}
          it_behaves_like :successful_profiles_count_and_ids
        end
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


      describe '- POST <create> - check after action'   do # , focus: true

        context '- after action <create> - check render_template & response status' do
          before {  post :create,
                         base_profile_id: base_profile_id,
                         profile_name_id: profile_name_id,
                         profile: profile_params  }

          it "- render_template create" do
            puts "Check profile #create\n"
            puts "In render_template :  currentuser_id = #{currentuser_id} \n"
            expect(subject).to render_template :create
          end
          it '- responds with 200' do
            puts "In responds with 200:  currentuser_id = #{currentuser_id} \n"
            expect(response.status).to eq(200)
          end
          it '- no responds with 401' do
            puts "In no responds with 401:  currentuser_id = #{currentuser_id} \n"
            expect(response.status).to_not eq(401)
          end

          describe '- check Profiles have rows count after CREATE  - Ok' do
            let(:rows_qty) {11}
            let(:rows_ids_arr) {[1, 85, 86, 87, 88, 89, 90, 91, 92, 172, 173]}
            it_behaves_like :successful_profiles_count_and_ids
          end
          describe '- check Tree have rows count before - Ok' do
            let(:rows_qty) {8}
            it_behaves_like :successful_tree_rows_count
          end
          describe '- check ProfileKey have rows count before - Ok' do
            let(:rows_qty) {50}
            it_behaves_like :successful_profile_keys_rows_count
          end
          describe '- check CommonLog have rows count before - Ok' do
            let(:rows_qty) {5}
            it_behaves_like :successful_common_logs_rows_count
          end
          it '- check CommonLog 1st & last row - Ok' do # , focus: true
            common_log_row_fields = CommonLog.last.attributes.except('created_at','updated_at')
            expect(common_log_row_fields).to eq({"id"=>5, "user_id"=>9, "log_type"=>1, "log_id"=>3, "profile_id"=>1,
                                                 "base_profile_id"=>92, "relation_id"=>5} )
          end

        end

      end

    end


    describe 'GET #destroy'  do # , focus: true

      let(:current_user) { User.find(9) }   # User = 9. Tree = 1. profile_id = 85
      let(:currentuser_id) {current_user.id}

      let(:base_profile_id) {92}
      let(:profile_name_id) {465}
      let(:profile_params) {{relation_id: 5}}

      context '1 - before action <create> - check ' do

        describe '- check User have rows count before - Ok' do
          let(:rows_qty) {9}
          it_behaves_like :successful_users_rows_count
        end
        describe '- check Profiles have rows count before - Ok' do
          let(:rows_qty) {10}
          let(:rows_ids_arr) {[85, 86, 87, 88, 89, 90, 91, 92, 172, 173]}
          it_behaves_like :successful_profiles_count_and_ids
        end
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


      describe '- POST <create> - check after action'   do  # , focus: true

        context '2 - after action <create> - check render_template & response status' do
          before {  post :create,
                         base_profile_id: base_profile_id,
                         profile_name_id: profile_name_id,
                         profile: profile_params  }

          it "- render_template create" do
            puts "Check profile #create\n"
            puts "In render_template :  currentuser_id = #{currentuser_id} \n"
            expect(subject).to render_template :create
          end
          it '- responds with 200' do
            puts "In responds with 200:  currentuser_id = #{currentuser_id} \n"
            expect(response.status).to eq(200)
          end
          it '- no responds with 401' do
            puts "In no responds with 401:  currentuser_id = #{currentuser_id} \n"
            expect(response.status).to_not eq(401)
          end

          describe '- check Profiles have rows count after CREATE  - Ok' do
            let(:rows_qty) {11}
            let(:rows_ids_arr) {[1, 85, 86, 87, 88, 89, 90, 91, 92, 172, 173]}
            it_behaves_like :successful_profiles_count_and_ids
          end
          describe '- check Tree have rows count after - Ok' do
            let(:rows_qty) {8}
            it_behaves_like :successful_tree_rows_count
          end
          describe '- check ProfileKey have rows count after - Ok' do
            let(:rows_qty) {50}
            it_behaves_like :successful_profile_keys_rows_count
          end
          describe '- check CommonLog have rows count after - Ok' do
            let(:rows_qty) {5}
            it_behaves_like :successful_common_logs_rows_count
          end
          it '- check CommonLog 1st & last row - Ok' do # , focus: true
            common_log_row_fields = CommonLog.last.attributes.except('created_at','updated_at')
            expect(common_log_row_fields).to eq({"id"=>5, "user_id"=>9, "log_type"=>1, "log_id"=>3, "profile_id"=>1,
                                                 "base_profile_id"=>92, "relation_id"=>5} )
          end

        end

      end


      describe '- GET <destroy> - check after action'   do  # , focus: true

        let(:destroy_id) {1}    # profile_id to destroy

        context '3 - after action <create> and <destroy> - check render_template & response status' do
          before {  post :create,
                         base_profile_id: base_profile_id,
                         profile_name_id: profile_name_id,
                         profile: profile_params
                    get :destroy, id: destroy_id }

          it "- render_template destroy" do
            puts "Check profile #destroy\n"
            puts "In render_template :  currentuser_id = #{currentuser_id} \n"
            expect(subject).to render_template :destroy
          end
          it '- responds with 200' do
            puts "In responds with 200:  currentuser_id = #{currentuser_id} \n"
            expect(response.status).to eq(200)
          end
          it '- no responds with 401' do
            puts "In no responds with 401:  currentuser_id = #{currentuser_id} \n"
            expect(response.status).to_not eq(401)
          end

          describe '- check Profiles have rows count after <create> and <destroy>  - Ok' do
            let(:rows_qty) {11}
            let(:rows_ids_arr) {[1, 85, 86, 87, 88, 89, 90, 91, 92, 172, 173]}
            it_behaves_like :successful_profiles_count_and_ids
          end
          describe '- check Tree have rows count after - Ok' do
            let(:rows_qty) {8}
            it_behaves_like :successful_tree_rows_count
          end
          describe '- check ProfileKey have rows count after - Ok' do
            let(:rows_qty) {50}
            it_behaves_like :successful_profile_keys_rows_count
          end
          describe '- check CommonLog have rows count after - Ok' do
            let(:rows_qty) {6}
            it_behaves_like :successful_common_logs_rows_count
          end
          it '- check CommonLog 1st & last row - Ok' do # , focus: true
            common_log_row_fields = CommonLog.last.attributes.except('created_at','updated_at')
            expect(common_log_row_fields).to eq({"id"=>6, "user_id"=>9, "log_type"=>2, "log_id"=>3, "profile_id"=>1,
                                                 "base_profile_id"=>92, "relation_id"=>5} )
          end
          it '- check DeletionLog 1st & last row - Ok' do # , focus: true
            deletion_log_row_fields = DeletionLog.first.attributes.except('created_at','updated_at')
            expect(deletion_log_row_fields).to eq({"id"=>1, "log_number"=>3, "current_user_id"=>9,
                                                   "table_name"=>"trees", "table_row"=>8, "field"=>"deleted",
                                                   "written"=>1, "overwritten"=>0} )
          end
          it '- check DeletionLog 1st & last row - Ok' do # , focus: true
            deletion_log_row_fields = DeletionLog.second.attributes.except('created_at','updated_at')
            expect(deletion_log_row_fields).to eq({"id"=>2, "log_number"=>3, "current_user_id"=>9,
                                                   "table_name"=>"profile_keys", "table_row"=>47, "field"=>"deleted",
                                                   "written"=>1, "overwritten"=>0} )
          end
          it '- check DeletionLog 1st & last row - Ok' do # , focus: true
            deletion_log_row_fields = DeletionLog.third.attributes.except('created_at','updated_at')
            expect(deletion_log_row_fields).to eq({"id"=>3, "log_number"=>3, "current_user_id"=>9,
                                                   "table_name"=>"profile_keys", "table_row"=>48, "field"=>"deleted",
                                                   "written"=>1, "overwritten"=>0} )
          end
          it '- check DeletionLog 1st & last row - Ok' do # , focus: true
            deletion_log_row_fields = DeletionLog.fourth.attributes.except('created_at','updated_at')
            expect(deletion_log_row_fields).to eq({"id"=>4, "log_number"=>3, "current_user_id"=>9,
                                                   "table_name"=>"profile_keys", "table_row"=>49,
                                                   "field"=>"deleted", "written"=>1, "overwritten"=>0} )
          end
          it '- check DeletionLog 1st & last row - Ok' do # , focus: true
            deletion_log_row_fields = DeletionLog.last.attributes.except('created_at','updated_at')
            expect(deletion_log_row_fields).to eq({"id"=>5, "log_number"=>3, "current_user_id"=>9,
                                                   "table_name"=>"profile_keys", "table_row"=>50, "field"=>"deleted",
                                                   "written"=>1, "overwritten"=>0} )
          end
          describe '- check DeletionLog have rows count after - Ok' do
            let(:rows_qty) {5}
            it_behaves_like :successful_deletion_logs_rows_count
          end

        end

      end


      describe '- GET <destroy> - check after rollback_destroy'   do  # , focus: true

        let(:destroy_id) {1}
        let(:common_log_id) {6}

        context '3 - after action <create> and <destroy> - check tables' do
          before {  post :create,
                         base_profile_id: base_profile_id,
                         profile_name_id: profile_name_id,
                         profile: profile_params
                    get :destroy, id: destroy_id
                    CommonLog.rollback_delete_profile(common_log_id, current_user) }

          describe '- check Profiles have rows count after <create> and <destroy>  - Ok' do
            let(:rows_qty) {11}
            let(:rows_ids_arr) {[1, 85, 86, 87, 88, 89, 90, 91, 92, 172, 173]}
            it_behaves_like :successful_profiles_count_and_ids
          end
          describe '- check Tree have rows count after - Ok' do  # change here
            let(:rows_qty) {8}
            it_behaves_like :successful_tree_rows_count
          end
          describe '- check ProfileKey have rows count after - Ok' do   # change here
            let(:rows_qty) {50}
            it_behaves_like :successful_profile_keys_rows_count
          end
          describe '- check CommonLog have rows count after - Ok' do
            let(:rows_qty) {5}
            it_behaves_like :successful_common_logs_rows_count
          end
          it '- check CommonLog 1st & last row - Ok' do # , focus: true
            common_log_row_fields = CommonLog.last.attributes.except('created_at','updated_at')
            expect(common_log_row_fields).to eq({"id"=>5, "user_id"=>9, "log_type"=>1, "log_id"=>3, "profile_id"=>1,
                                                 "base_profile_id"=>92, "relation_id"=>5} )
          end
          describe '- check DeletionLog have rows count after - Ok' do
            let(:rows_qty) {0}
            it_behaves_like :successful_deletion_logs_rows_count
          end

        end

      end




    end






  end

end
