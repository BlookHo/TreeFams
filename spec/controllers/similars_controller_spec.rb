describe SimilarsController, :type => :controller , similars: true do


    let(:current_user) { create(:user) }   # User = 1. Tree = 1. profile_id = 63
    let(:currentuser_id) {current_user.id}

    before {
      allow(controller).to receive(:logged_in?)
      allow(controller).to receive(:current_user).and_return current_user
      # puts "1 before All: currentuser_id = #{currentuser_id} \n" # currentuser_id = 1
      # puts "before All: current_user.profile_id = #{current_user.profile_id} \n"

      FactoryGirl.create(:user, :user_2)  # User = 2. Tree = 2. profile_id = 66
      puts "before All: User.last.id = #{User.last.id} \n" # id = 2

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
      puts "before All: Tree.count = #{Tree.all.count} \n" # 20

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
      puts "before All: Profile.count = #{Profile.all.count} \n" # 2

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
      puts "before All: ProfileKey.count = #{ProfileKey.all.count} \n" # 112

      #Weafam_Settings
      FactoryGirl.create(:weafam_setting)
      # puts "before All: WeafamSetting.first.certain_koeff = #{WeafamSetting.first.certain_koeff} \n"  # 4

      #Name
      FactoryGirl.create(:name, :name_40)
      FactoryGirl.create(:name, :name_173)
      FactoryGirl.create(:name, :name_351)
      FactoryGirl.create(:name, :name_354)
      FactoryGirl.create(:name, :name_370)
      FactoryGirl.create(:name, :name_422)
      # puts "before All: Name.first.name = #{Name.first.name} \n"  # Андрей

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
      # SimilarsFound.delete_all
      # SimilarsFound.reset_pk_sequence
    }

  describe 'CHECK SimilarsController methods' do

    context '- before actions - check connected_users' do
      let(:connected_users) { current_user.get_connected_users }
      it "- Return proper connected_users Array result for current_user_id = 1" do
        # puts "1 1 In check connected_users :  connected_users = #{connected_users} \n"
        expect(connected_users).to be_a_kind_of(Array)
      end
      it "- Return proper connected_users Array result for current_user_id = 1" do
        # puts "1 2 In check connected_users :  connected_users = #{connected_users} \n"
        expect(connected_users).to eq([1,2])
      end
    end

     describe 'GET #internal_similars_search' do

      context '- after action <internal_similars_search> - check render_template & response status' do
        subject { get :internal_similars_search
        # puts "In subject after action - currentuser_id = #{currentuser_id} \n"      # 1
        # puts "In subject - current_user.profile_id = #{current_user.profile_id} \n" # 63
        }
        it "- render_template internal_similars_search" do
          puts "In render_template :  currentuser_id = #{currentuser_id} \n"
          expect(subject).to render_template :internal_similars_search
        end
        it '- responds with 200' do
          puts "In responds with 200:  currentuser_id = #{currentuser_id} \n"
          expect(response.status).to eq(200)
        end
         it '- no responds with 401' do
          puts "In no responds with 401:  currentuser_id = #{currentuser_id} \n"
          expect(response.status).to_not eq(401)
        end
      end

      context '- In action <internal_similars_search> - check instances  ' do
        it "- got values: log_connection_id, connected_users, current_user_id" do
          get :internal_similars_search
          puts "In check instances :  currentuser_id = #{currentuser_id} \n"  # 1
          # puts "In check instances :  current_user.profile_id = #{current_user.profile_id} \n" # 63
          expect(assigns(:log_connection_id)).to eq([])
          expect(assigns(:connected_users)).to eq([1,2])
          expect(assigns(:current_user_id)).to eq(1)
        end
      end

      context '- After action <internal_similars_search>: check results got' do
        before {get :internal_similars_search}

        it '- tree_info: tree_is_profiles, tree_profiles_amount - Ok' do
          puts "In check results: tree_info \n"
          expect(assigns(:tree_info)).to include(:tree_is_profiles => [81, 70, 63, 83, 66, 64, 79, 68, 78, 65, 80, 69, 82, 67, 84])
          expect(assigns(:tree_info)).to include(:tree_profiles_amount => 15)
          expect(assigns(:tree_info)).to include(:users_profiles_ids=>[63, 66])
        end

        it '- new_sims - Ok' do
          expect(assigns(:new_sims)).to eq("New sims")
          puts "In check results: new_sims \n"
        end

        it '- log_connection_id - Ok' do
          puts "In check results: log_connection_id \n"
          expect(assigns(:log_connection_id)).to eq([])
        end

        it '- similars - Ok' do
          puts "In check results: similars \n"
          expect(assigns(:similars)).to eq( [
            {:first_profile_id=>81, :first_name_id=>"Ольга", :first_relation_id=>"Сестра", :name_first_relation_id=>"Елены",
             :first_sex_id=>"Ж", :second_profile_id=>70, :second_name_id=>"Ольга", :second_relation_id=>"Жена",
             :name_second_relation_id=>"Петра", :second_sex_id=>"Ж",
             :common_relations=>{"Отец"=>[351], "Мама"=>[187], "Сестра"=>[173], "Муж"=>[370]},
             :common_power=>4, :inter_relations=>[]},
            {:first_profile_id=>79, :first_name_id=>"Олег", :first_relation_id=>"Отец", :name_first_relation_id=>"Ольги",
             :first_sex_id=>"М", :second_profile_id=>82, :second_name_id=>"Олег", :second_relation_id=>"Отец",
             :name_second_relation_id=>"Елены", :second_sex_id=>"М",
             :common_relations=>{"Дочь"=>[173, 354], "Жена"=>[187], "Зять"=>[370]},
             :common_power=>4, :inter_relations=>[]}] )
        end

        it '- in SimilarsFound stored 2 rows of good sims pairs & first row - Ok' do
          sims_count =  SimilarsFound.all.count
          puts "In check SimilarsFound count rows: rows sims_count = #{sims_count.inspect} \n"
          expect(sims_count).to eq(2) # got 2 rows of similars
        end

        it '- First row stored in SimilarsFound of good sims pair - Ok' do
          first_row = SimilarsFound.first
          expect(first_row.first_profile_id).to eq(81)
          expect(first_row.second_profile_id).to eq(70)
          puts "In check SimilarsFound rows:  first_row.second_profile_id = #{first_row.second_profile_id.inspect} \n"
        end

        it '- Second row stored in SimilarsFound of good sims pair - Ok' do
          second_row = SimilarsFound.second
          expect(second_row.first_profile_id).to eq(79)
          expect(second_row.second_profile_id).to eq(82)
          puts "In check SimilarsFound rows:  second_row.second_profile_id = #{second_row.second_profile_id.inspect} \n"
        end

      end

     end

    describe 'GET #connect_similars' do

      let(:first_init_profile) {81}
      let(:second_init_profile) {70}
      let(:similars_count) {SimilarsFound.all.count}
      let(:first_row) {SimilarsFound.first}

      context '- After action <connect_similars>: check render_template & response status' do
        before  { get :internal_similars_search }
        subject { get :connect_similars,
                       first_profile_id: first_init_profile, second_profile_id: second_init_profile,
                       :format => 'js'        }
        it "- <connect_similars> respond content_type" do
          puts "In responds with = text/html' \n"
          expect(response.content_type).to eq("text/html")
        end
        it "- render_template <connect_similars>" do
          puts "In responds render_template: 'similars/connect_similars' \n"
          expect(subject).to render_template 'similars/connect_similars'
        end
        it '- responds with 200' do
          puts "In responds with 200:  currentuser_id = #{currentuser_id} \n"
          expect(response.status).to eq(200)
        end
        it '- no responds with 401' do
          puts "In no responds with 401:  currentuser_id = #{currentuser_id} \n"
          expect(response.status).to_not eq(401)
        end
      end

      context '- After action <connect_similars>: check instances ' do
        before { get :internal_similars_search
                 puts "In connect_similars SimilarsFound count rows:  similars_count = #{similars_count.inspect} \n"
                 get :connect_similars,
                     first_profile_id: first_init_profile, second_profile_id: second_init_profile,
                     :format => 'js' }
        it "- got values: init_hash" do
          puts "In check instances :  init_hash \n"
          expect(assigns(:init_hash)).to eq( {81=>70, 82=>79, 83=>80, 67=>78, 84=>66} )
        end

        it "- got values: profiles_to_rewrite, profiles_to_destroy" do
          puts "In check instances:  profiles_to_rewrite, profiles_to_destroy \n"
          expect(assigns(:profiles_to_rewrite)).to eq( [81, 82, 83, 67, 84] )
          expect(assigns(:profiles_to_destroy)).to eq( [70, 79, 80, 78, 66] )
        end
      end

      context '- Before action <connect_similars>: check SimilarsFound ' do
        before {  get :internal_similars_search
                  puts "In connect_similars SimilarsFound count rows:  similars_count = #{similars_count.inspect} \n" }
         it '- SimilarsFound got 2 rows - Ok' do
          similars_pairs_count =  SimilarsFound.all.count
          puts "In check SimilarsFound count rows:  similars_pairs_count = #{similars_pairs_count.inspect} \n"
          expect(similars_pairs_count).to eq(2) # got 2 rows of similars
        end
        it '- SimilarsFound got similars pairs - Ok' do
          first_row2 =  SimilarsFound.first
          puts "In check SimilarsFound count rows:  first_row2 = #{first_row2.inspect} \n"
          expect(first_row2.second_profile_id).to eq(70) # got 2 rows of similars
        end
      end

      context '- After action <connect_similars>: check SimilarsLog ' do
        before {  get :internal_similars_search
                  get :connect_similars,
                      first_profile_id: first_init_profile, second_profile_id: second_init_profile,
                      :format => 'js' }
        it '- SimilarsLog got rows - Ok' do
          logs_count =  SimilarsLog.all.count
          puts "In check SimilarsLog count rows:  logs_count = #{logs_count.inspect} \n"
          expect(logs_count).to eq(82) # got 2 rows of similars
        end
      end

    end

    describe 'GET #connect_similars' do



    end



  end


end


#
#
# context '- after action - render/redirection ' do
#   it "- render_template internal_similars_search" do
#     puts "In render_template :  current_user_id = #{current_user_id} \n"
#     puts "In render_template :  current_user.profile_id = #{current_user.profile_id} \n"
#     expect(subject).to render_template :internal_similars_search
#   end
# end
#
# context '- after action - check response status' do
#   it 'responds with 200' do
#     get :internal_similars_search
#     puts "In responds with 200:  current_user_id = #{current_user_id} \n"
#     expect(response.status).to eq(200)
#   end
# end
#
# context '- after action - responds with 200 Ok status ' do
#   it 'no responds with 401' do
#     puts "In no responds with 401:  current_user_id = #{current_user_id} \n"
#     expect(response.status).to_not eq(401)
#   end
# end


# context '- in action: get tree_info & similars & sim_data ' do
#   it "- receive similars & sim_data in internal_similars_search" do
#     expect(tree_info).to render_template :internal_similars_search
#
#   end

#   it "- receive similars & sim_data in internal_similars_search" do
#     expect(sim_data).to render_template :internal_similars_search
#
#   end

#   it "- receive similars & sim_data in internal_similars_search" do
#     expect(similars).to render_template :internal_similars_search
#
#   end

# end
