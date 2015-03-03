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
      puts "before All: User.find(2).profile_id = #{User.find(2).profile_id} \n" # id = 2

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
      SimilarsFound.delete_all
      SimilarsFound.reset_pk_sequence
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
        subject { get :internal_similars_search }
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
      end

      context '- After action <internal_similars_search>: check SimilarsFound' do
        it '- in SimilarsFound stored 2 rows of good sims pairs & first row - Ok' do
          get :internal_similars_search
          sims_count =  SimilarsFound.all.count
          puts "In check SimilarsFound count rows: rows sims_count = #{sims_count.inspect} \n"
          expect(sims_count).to eq(2) # got 2 rows of similars
          first_row = SimilarsFound.first
          expect(first_row.first_profile_id).to eq(81)
          expect(first_row.second_profile_id).to eq(70)
          puts "In check SimilarsFound rows:  first_row = #{first_row.inspect} \n"
          puts "In check SimilarsFound rows:  first_row.second_profile_id = #{first_row.second_profile_id.inspect} \n"
          second_row = SimilarsFound.second
          expect(second_row.first_profile_id).to eq(79)
          expect(second_row.second_profile_id).to eq(82)
          puts "In check SimilarsFound rows:  second_row = #{second_row.inspect} \n"
          puts "In check SimilarsFound rows:  second_row.second_profile_id = #{second_row.second_profile_id.inspect} \n"
        end

      end

     end

    describe 'GET #connect_similars' do

      let(:first_init_profile) {81}
      let(:second_init_profile) {70}

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

      context '- Before action <connect_similars>: check User ' do
        let(:connected_users) { current_user.get_connected_users }
        it '- in User_2 profile_id before changed - Ok' do
          user_2_before_profile_id = User.find(connected_users[1]).profile_id
          puts "before action <connect_similars> check in User: user_2_before_profile_id =
                       #{user_2_before_profile_id.inspect} \n"
          expect(user_2_before_profile_id).to eq(66) # profile_id of user2 - before connection
        end
      end

      context '- Before action <connect_similars>: check SimilarsLog for Tree' do
        let(:connected_users) { current_user.get_connected_users }
        let(:table_name) { Tree.table_name }

        it '- before action <connect_similars> got Empty array of [rows_ids] from Tree logs - Ok' do
          rows_ids = SimilarsLog.where(current_user_id: connected_users, table_name: table_name).pluck(:table_row)
          puts "before 1 action <connect_similars> check in Tree: table_name = #{table_name.inspect} \n"
          puts "before 1 action <connect_similars> check in Tree: rows_ids = #{rows_ids.inspect} \n"
          expect(rows_ids).to eq([]) # got rows_ids array for Tree logs before connection
        end
      end

      context '- Before action <connect_similars>: check SimilarsLog for ProfileKey' do
        let(:connected_users) { current_user.get_connected_users }
        let(:table_name) { ProfileKey.table_name }

        it '- before action <connect_similars> got Empty array of [rows_ids] from ProfileKey logs - Ok' do
          rows_ids = SimilarsLog.where(current_user_id: connected_users, table_name: table_name).pluck(:table_row)
          puts "before 1 action <connect_similars> check in ProfileKey: table_name = #{table_name.inspect} \n"
          puts "before 1 action <connect_similars> check in ProfileKey: rows_ids = #{rows_ids.inspect} \n"
          expect(rows_ids).to eq([]) # got rows_ids array for ProfileKey logs before connection
        end
      end

      context '- After action <connect_similars>: check SimilarsLog ' do
        before {  get :internal_similars_search
                  get :connect_similars,
                      first_profile_id: first_init_profile, second_profile_id: second_init_profile,
                      :format => 'js' }
        it '- SimilarsLog got rows count - Ok' do
          logs_count =  SimilarsLog.all.count
          puts "After action <connect_similars> check SimilarsLog count rows: logs_count = #{logs_count.inspect} \n"
          expect(logs_count).to eq(82) # got 82 rows of similars connecting logs
        end

        it '- log connected_at in SimilarsLog - Ok' do
          connected_at =  SimilarsLog.last.connected_at
          current_user_logged =  SimilarsLog.last.current_user_id
          puts "In check log connected_at in SimilarsLog:  connected_at = #{connected_at.inspect} \n"
          expect(connected_at).to eq(1) # got log connected_at of connected similars
          puts "In check log connected_at in SimilarsLog:  current_user_logged = #{current_user_logged.inspect} \n"
          expect(current_user_logged).to eq(1) # got log current_user_id of connected similars
        end
      end

      context '- After action <connect_similars>: check SimilarsFound ' do
        it '- SimilarsFound got 2 rows - Ok' do
          SimilarsFound.delete_all
          SimilarsFound.reset_pk_sequence
          get :internal_similars_search
          get :connect_similars,
              first_profile_id: first_init_profile, second_profile_id: second_init_profile,
              :format => 'js'
          similars_pairs_count =  SimilarsFound.all.count
          puts "After action <connect_similars> check SimilarsFound:  similars_pairs_count = #{similars_pairs_count.inspect} \n"
          expect(similars_pairs_count).to eq(0) # got 2 rows of similars
        end
      end

      context '- After action <connect_similars>: check User' do
        let(:user_2) {User.find(2)}
        let(:connected_users) { current_user.get_connected_users }
        it '- in User one row changed - Ok' do
          puts "before User one row changed: current_user.profile_id = #{current_user.profile_id} \n"
          puts "before User two row changed: user_2.id = #{user_2.id} \n"
          expect(user_2.profile_id).to eq(66) # got 2 rows of similars
          get :internal_similars_search
          get :connect_similars,
              first_profile_id: first_init_profile, second_profile_id: second_init_profile,
              :format => 'js'
          users_count =  User.all.count
          puts "After action <connect_similars> check in User: users_count = #{users_count.inspect} \n"
          user_1_profile =  User.find(currentuser_id).profile_id
          puts "After action <connect_similars> check in User: user_1_profile = #{user_1_profile.inspect} \n"
          expect(user_1_profile).to eq(63) # got profile_id of user_1
          # puts "After action: User.find(connected_users[1]).profile_id =
          #                #{User.find(connected_users[1]).profile_id} \n" # profile_id = 84
          user_2_profile =  User.find(connected_users[1]).profile_id
          puts "After action <connect_similars> check in User: user_2_profile = #{user_2_profile.inspect} \n"
          expect(user_2_profile).to eq(84) # got profile_id of user_2 = 84
        end
      end

      context '- After action <connect_similars>: check Profile' do
        let(:connected_users) { current_user.get_connected_users }
        it '- in Profile - before profiles rows changed - Ok' do
          user_2 = User.find(connected_users[1])
          puts "before 1 action <connect_similars> check User: before_profile_user = #{user_2.profile_id.inspect} \n"
          expect(user_2.profile_id).to eq(66) # got profile_id for 2nd user in User before connection = 66

          before_profile_new_user = Profile.find(user_2.profile_id).user_id
          puts "before 2 action <connect_similars> check Profile: before_profile_new_user = #{before_profile_new_user.inspect} \n"
          expect(before_profile_new_user).to eq(2) # got user_id for 2nd user profile in Profiles before connection = 2
        end

        it '- in Profile - After profiles rows changed - Ok' do
          get :internal_similars_search
          get :connect_similars,
              first_profile_id: first_init_profile, second_profile_id: second_init_profile,
              :format => 'js'

          profiles_users_count =  Profile.where(user_id: connected_users).count
          puts "After 1 action <connect_similars> check Profile: profiles_users_count = #{profiles_users_count.inspect} \n"
          expect(profiles_users_count).to eq(2) # got 2 rows of users in Profiles

          user_2 = User.find(connected_users[1])
          puts "After 2 action <connect_similars> check in User: after_profile_user = #{user_2.profile_id.inspect} \n"
          expect(user_2.profile_id).to eq(84) # got profile_id for 2nd user in User after connection = 84

          profile_new_user = Profile.find(user_2.profile_id).user_id
          puts "After 3 action <connect_similars> check in Profile: profile_new_user = #{profile_new_user.inspect} \n"
          expect(profile_new_user).to eq(2) # got new user_id for 2nd user profile in Profiles after connection = 2
        end
      end

      context '- After action <connect_similars>: check Tree' do
        let(:connected_users) { current_user.get_connected_users }
        let(:table_name) { Tree.table_name }
        let(:field_name_profile) { "profile_id" }
        let(:field_name_is_profile) { "is_profile_id" }

        before { get :internal_similars_search
                 get :connect_similars,
                  first_profile_id: first_init_profile, second_profile_id: second_init_profile, :format => 'js' }

        it '- in Tree - check SimilarsLog rows changed for "profile_id" field - Ok' do
          profile_rows_ids = SimilarsLog.where(current_user_id: connected_users, table_name: table_name,
                                               field: field_name_profile)
                                               .pluck(:table_row).sort
          puts "after 1 action <connect_similars> check in Tree: profile_rows_ids = #{profile_rows_ids.inspect} \n"
          expect(profile_rows_ids).to eq([7, 8, 9, 10, 11, 14, 15, 16]) # got rows_ids array for Tree logs before connection
        end

        it '- in Tree - check fields changed for "profile_id" in proper rows to proper values - Ok' do
          profile_rows_ids = SimilarsLog.where(current_user_id: connected_users, table_name: table_name,
                                               field: field_name_profile)
                                               .pluck(:table_row).sort
          profile_values_written = []
          profile_rows_ids.each do |row|
            profile_values_written << Tree.find(row).profile_id
          end
          puts "after 2 action <connect_similars> check in Tree: profile_values_written = #{profile_values_written.inspect} \n"
          expect(profile_values_written).to eq([84, 84, 84, 84, 84, 81, 81, 82]) # got proper values array in fields changed
          # for "profile_id" in Tree after connection
        end

        it '- in Tree - check SimilarsLog rows changed for "IS_profile_id" field - Ok' do
          is_profile_rows_ids = SimilarsLog.where(current_user_id: connected_users, table_name: table_name,
                                                  field: field_name_is_profile)
                                                  .pluck(:table_row).sort
          puts "after 1 action <connect_similars> check in Tree: is_profile_rows_ids = #{is_profile_rows_ids.inspect} \n"
          expect(is_profile_rows_ids).to eq([3, 7, 11, 14, 15, 16]) # got rows_ids array for Tree logs before connection
        end

        it '- in Tree - check fields changed for "profile_id" in proper rows to proper values - Ok' do
          is_profile_rows_ids = SimilarsLog.where(current_user_id: connected_users, table_name: table_name,
                                                  field: field_name_is_profile)
                                                  .pluck(:table_row).sort
          is_profile_values_written = []
          is_profile_rows_ids.each do |row|
            is_profile_values_written << Tree.find(row).is_profile_id
          end
          puts "after 2 action <connect_similars> check in Tree: is_profile_values_written = #{is_profile_values_written.inspect} \n"
          expect(is_profile_values_written).to eq([84, 81, 81, 67, 82, 83]) # got proper values array in fields changed
          # for "is_profile_id" in Tree after connection
        end

      end

      context '- After action <connect_similars>: check ProfileKey' do
        let(:connected_users) { current_user.get_connected_users }
        let(:table_name) { ProfileKey.table_name }
        let(:field_name_profile) { "profile_id" }
        let(:field_name_is_profile) { "is_profile_id" }

        before { get :internal_similars_search
        get :connect_similars,
            first_profile_id: first_init_profile, second_profile_id: second_init_profile, :format => 'js' }

        it '- in ProfileKey - check SimilarsLog rows changed for "profile_id" field - Ok' do
          profile_rows_ids = SimilarsLog.where(current_user_id: connected_users, table_name: table_name,
                                               field: field_name_profile)
                                 .pluck(:table_row).sort
          puts "after 1 action <connect_similars> check in ProfileKey: profile_rows_ids = #{profile_rows_ids.inspect} \n"
          expect(profile_rows_ids).to eq([8, 10, 12, 23, 33, 37, 38, 40, 42, 43, 45, 49, 55, 56, 58, 60, 63, 73, 79,
                                          80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92])
                                          # got rows_ids array for ProfileKey logs before connection
        end

        it '- in ProfileKey - check fields changed for "profile_id" in proper rows to proper values - Ok' do
          profile_rows_ids = SimilarsLog.where(current_user_id: connected_users, table_name: table_name,
                                               field: field_name_profile)
                                 .pluck(:table_row).sort
          profile_values_written = []
          profile_rows_ids.each do |row|
            profile_values_written << ProfileKey.find(row).profile_id
          end
          puts "after 2 action <connect_similars> check in ProfileKey: profile_values_written = #{profile_values_written.inspect} \n"
          expect(profile_values_written).to eq([84, 84, 84, 84, 84, 84, 81, 81, 81, 84, 84, 84, 84, 81, 81, 81, 84,
                                                84, 81, 67, 81, 82, 67, 82, 84, 82, 82, 83, 81, 83, 67, 83])
                                                # got proper values array in fields changed
          # for "profile_id" in ProfileKey after connection
        end

        it '- in ProfileKey - check SimilarsLog rows changed for "IS_profile_id" field - Ok' do
          is_profile_rows_ids = SimilarsLog.where(current_user_id: connected_users, table_name: table_name,
                                                  field: field_name_is_profile)
                                    .pluck(:table_row).sort
          puts "after 1 action <connect_similars> check in ProfileKey: is_profile_rows_ids = #{is_profile_rows_ids.inspect} \n"
          expect(is_profile_rows_ids).to eq([7, 9, 11, 24, 34, 37, 38, 39, 41, 44, 46, 50, 55, 56, 57, 59, 64, 74,
                                             79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92])
                                             # got rows_ids array for ProfileKey logs before connection
        end

        it '- in ProfileKey - check fields changed for "profile_id" in proper rows to proper values - Ok' do
          is_profile_rows_ids = SimilarsLog.where(current_user_id: connected_users, table_name: table_name,
                                                  field: field_name_is_profile)
                                    .pluck(:table_row).sort
          is_profile_values_written = []
          is_profile_rows_ids.each do |row|
            is_profile_values_written << ProfileKey.find(row).is_profile_id
          end
          puts "after 2 action <connect_similars> check in ProfileKey: is_profile_values_written =
                                       #{is_profile_values_written.inspect} \n"
          expect(is_profile_values_written).to eq([84, 84, 84, 84, 84, 81, 84, 81, 81, 84, 84, 84, 81, 84, 81, 81,
                                                   84, 84, 67, 81, 82, 81, 82, 67, 82, 84, 83, 82, 83, 81, 83, 67])
                                                    # got proper values array in fields changed
          # for "is_profile_id" in ProfileKey after connection
        end

      end

    end

    describe 'GET #disconnect_similars' do
      let(:first_init_profile) {81}
      let(:second_init_profile) {70}
      let(:log_connection_id) {1}

      context '- After action <disconnect_similars>: check render_template & response status' do
        before { get :internal_similars_search
                 get :connect_similars,
                     first_profile_id: first_init_profile, second_profile_id: second_init_profile,
                     :format => 'js' }
        subject { get :disconnect_similars, log_connection_id: log_connection_id, :format => 'js' }
        it "- <disconnect_similars> respond content_type" do
          puts "In responds with = text/html' \n"
          expect(response.content_type).to eq("text/html")
        end
        it "- render_template <disconnect_similars>" do
          puts "In responds render_template: 'similars/disconnect_similars' \n"
          expect(subject).to render_template 'similars/disconnect_similars'
        end
        it '- responds <disconnect_similars> with 200' do
          puts "In responds with 200: currentuser_id = #{currentuser_id} \n"
          expect(response.status).to eq(200)
        end
        it '- no responds <disconnect_similars> with 401' do
          puts "In no responds with 401: currentuser_id = #{currentuser_id} \n"
          expect(response.status).to_not eq(401)
        end
      end

      context '- After action <disconnect_similars>: check SimilarsLog ' do
        it '- SimilarsLog rows deleted - got rows count = 0 - Ok' do
          get :internal_similars_search
          get :connect_similars,
              first_profile_id: first_init_profile, second_profile_id: second_init_profile,
              :format => 'js'
          get :disconnect_similars, log_connection_id: log_connection_id, :format => 'js'
          logs_count =  SimilarsLog.all.count
          puts "After <disconnect_similars> check SimilarsLog: logs_count = #{logs_count.inspect} \n"
          expect(logs_count).to eq(0) # after deleting - got 0 rows of similars connecting logs
        end
      end

      context '- After action <disconnect_similars>: check SimilarsFound ' do
        # после disconnect_similars SimilarsFound д. иметь похожие пары: 1) 81;70 or 70:81  2) 79;82 or 82:79
        before {
          SimilarsFound.delete_all
          SimilarsFound.reset_pk_sequence
          get :internal_similars_search
          get :connect_similars,
              first_profile_id: first_init_profile, second_profile_id: second_init_profile,
              :format => 'js'
          get :disconnect_similars, log_connection_id: log_connection_id, :format => 'js'
        }
        it '- SimilarsFound got 2 sims rows - Ok' do
           sims_pairs_count =  SimilarsFound.all.count
          puts "After <disconnect_similars> check SimilarsFound:  sims_pairs_count = #{sims_pairs_count.inspect} \n"
          expect(sims_pairs_count).to eq(2) # got 2 rows of similars
        end
        it '- SimilarsFound got good sims 1st pair - Ok' do
          first_row3 = SimilarsFound.first
          puts "After <disconnect_similars> check SimilarsFound sims pair: first_row3 = #{first_row3.inspect} \n"
          first_row_profile1 = first_row3.first_profile_id
          first_row_profile2 = first_row3.second_profile_id
          sim_pair1 = [first_row_profile1, first_row_profile2].sort
          expect(sim_pair1).to eq([70, 81]) # got 1st pair of similars
          puts "After <disconnect_similars> check SimilarsFound: sim_pair1 = #{sim_pair1.inspect} \n"
        end
        it '- SimilarsFound got good sims 2nd pair - Ok' do
          second_row3 = SimilarsFound.second
          puts "After <disconnect_similars> check SimilarsFound sims pair: second_row3 = #{second_row3.inspect} \n"
          second_row_profile1 = second_row3.first_profile_id
          second_row_profile2 = second_row3.second_profile_id
          sim_pair2 = [second_row_profile1, second_row_profile2].sort
          expect(sim_pair2).to eq([79, 82]) # got 2nd pair of similars
          puts "After <disconnect_similars> check SimilarsFound sims pair: sim_pair2 = #{sim_pair2.inspect} \n"
        end
      end



  # пометить те ряды, кот-е меняются при объед/разъед (см. в Логах - row_number)
  # их и надо тестировать на корректность изменений туда-сюда




    end



  end


end

