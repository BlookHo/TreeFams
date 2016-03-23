require 'rails_helper'

RSpec.describe SearchServiceLogs, type: :model    do  #, focus: true

  describe '- Validation'   do
    context '- valid search_service_logs'    do  # , focus: true
      it "has a valid factory"    do
        puts " Model SearchServiceLogs validation - has a valid factory - Ok -"
        expect(FactoryGirl.create(:test_search_service_logs)).to be_valid
      end
      let(:good_search_service_logs) {FactoryGirl.create(:search_service_logs)}
      it '- 1 Saves a valid search_service_logs' do
        expect(good_search_service_logs).to be_valid
      end
      let(:good_search_service_logs_correct2) {FactoryGirl.create(:search_service_logs, :correct2)}
      it '- 2 Saves a valid search_service_logs - correct2' do
        expect(good_search_service_logs_correct2).to be_valid
      end
      let(:good_search_service_logs_correct3) {FactoryGirl.create(:search_service_logs, :correct3)}
      it '- 3 Saves a valid search_service_logs - correct3' do
        expect(good_search_service_logs_correct3).to be_valid
      end
    end

    context '- invalid search_service_logs'    do  #    , focus: true
      let(:invalid_search_service_logs_search_event) {FactoryGirl.build(:search_service_logs, :uncorrect_search_event)}
      it "1 Build invalid factory - uncorrect_search_event "    do
        puts " Model SearchServiceLogs validation - has invalid factories - Ok - "
        expect(invalid_search_service_logs_search_event).to_not be_valid
      end
      let(:invalid_search_service_logs_time) {FactoryGirl.build(:search_service_logs, :uncorrect_time)}
      it '- 2 Build invalid search_service_logs - uncorrect_time '  do
        expect(invalid_search_service_logs_time).to_not be_valid
      end
      let(:invalid_search_service_searched_profiles) {FactoryGirl.build(:search_service_logs, :uncorrect_searched_profiles)}
      it '- 3 Build invalid search_service_logs - uncorrect_searched_profiles' do
        expect(invalid_search_service_searched_profiles).to_not be_valid
      end
      let(:invalid_search_service_all_tree_profiles) {FactoryGirl.build(:search_service_logs, :uncorrect_all_tree_profiles)}
      it '- 4 Build invalid search_service_logs - all_tree_profiles' do
        expect(invalid_search_service_all_tree_profiles).to_not be_valid
      end
    end
  end

  context '- check SearchServiceLogs methods'      do #  , focus: true
    before {

      # User current_user_1_connected
      FactoryGirl.create(:user, :current_user_1_connected )  # User = 1 . Tree = [1,2]. profile_id = 17
      FactoryGirl.create(:user, :user_2_connected )  # User = 2 . Tree = [1,2]. profile_id = 11
      # puts "before All: User.last.id = #{User.last.id}, .profile_id = #{User.last.profile_id} \n"  # user_id = 1
      FactoryGirl.create(:user, :user_3_to_connect )  # User = 3 . Tree = [3]. profile_id = 22

      # ConnectedUser
      FactoryGirl.create(:connected_user, :correct)      # 1  2

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

      # WeafamStat
      FactoryGirl.create(:weafam_stat, :weafam_stat_1)      #
      FactoryGirl.create(:weafam_stat, :weafam_stat_2)      #
      FactoryGirl.create(:weafam_stat, :weafam_stat_3)      #

    }

    after {
      User.delete_all
      User.reset_pk_sequence
      ConnectedUser.delete_all
      ConnectedUser.reset_pk_sequence
      Profile.delete_all
      Profile.reset_pk_sequence
      SearchServiceLogs.delete_all
      SearchServiceLogs.reset_pk_sequence
      WeafamStat.delete_all
      WeafamStat.reset_pk_sequence
    }

    # create User parameters
    let(:current_user_1) { User.first }  # User = 1. Tree = [1,2]. profile_id = 17
    let(:current_user_1_id) { User.first.id }  # user_id = 1. Tree = [1,2]. profile_id = 17
    describe 'Method store_search_time_log in <start_search> test'   do # , focus: true

      context "- Check Method logged_actual_profiles -"   do  # , focus: true # User = 1. Tree = [1,2]. profile_id = 17
        let(:search_event) { 2 } # :name) {  "Удален профиль"
        let(:time) {  110.93 }
        let(:connected_users) { current_user_1.connected_users }
        let(:searched_profiles) { 16 }
        let(:all_tree_profiles) { 26 }
        let(:all_profiles) { 155 }
        let(:store_log_data) {{ search_event: search_event,
                                time: time,
                                connected_users: connected_users,
                                user_id: current_user_1_id,
                                searched_profiles: searched_profiles,
                                all_tree_profiles: all_tree_profiles,
                                all_profiles: all_profiles } }

        before { SearchServiceLogs.store_search_time_log(store_log_data) }

        let(:current_profile) { Profile.find(current_user_1.profile_id) }
        it '- check current_user_1.profile_id - Ok' do
          puts "check store_search_time_log: current_user_1.profile_id = #{current_user_1.profile_id.inspect} \n"
          expect(current_user_1.profile_id).to eq(17)
        end
        it '- check connected_users - Ok' do
          puts "before: connected_users = #{connected_users.inspect} \n"
          expect(connected_users).to eq([1,2])
        end
        it '- check current_profile.id - Ok' do
          puts "before: current_profile.id = #{current_profile.id.inspect} \n"
          expect(current_profile.id).to eq(17)
        end
        it ' - check SearchServiceLogs First stored row - Ok' do # , focus: true
          puts "check After SearchServiceLogs.store_search_time_log - Ok\n"   # 0
          search_service_logs = SearchServiceLogs.find(1).attributes.except('created_at','updated_at')
          expect(search_service_logs).to eq({"id"=>1, "name"=>"Удален профиль", "search_event"=>2, "time"=>110.93,
                                             "connected_users"=> [1, 2], "searched_profiles"=>16,
                                             "ave_profile_search_time"=> 6.933, "all_tree_profiles"=>26,
                                             "all_profiles"=>195, "user_id"=>1 } )
        end
      end

    end

  end


end

