require 'rails_helper'

RSpec.describe Event, type: :model   do  # , focus: true

  describe '- validation' do
    describe '- on create' do

      context '- valid Faker event' do
        let(:event_row) {FactoryGirl.build(:event)}  #
        it '- saves a valid Faker event_row' do
          puts " Model Faker Event validation "
          expect(event_row).to be_valid
        end
      end
      context '- valid event one row' do
        let(:event_row) {FactoryGirl.build(:event_common)}  #
        it '- saves a valid event_row' do
          puts " Model Event validation "
          expect(event_row).to be_valid
        end
      end
      context '- invalid event_type_row' do
        let(:bad_type_number) {FactoryGirl.build(:event_common, :type_uncorrect)}
        it '- 1 Dont save: - bad_type_number - more 26' do
          expect(bad_type_number).to_not be_valid
        end
        let(:bad_profile_id) {FactoryGirl.build(:event_common, :profile_id_uncorrect)}
        it '- 2 Dont save: - bad profile_id - == 0' do
          expect(bad_profile_id).to_not be_valid
        end
        let(:bad_agent_user_id) {FactoryGirl.build(:event_common, :agent_user_id_uncorrect)}
        it '- 3 Dont save: - bad agent_user_id - == 0' do
          expect(bad_agent_user_id).to_not be_valid
        end
      end

    end

  end

  describe 'Event model methods test'  , focus: true    do   # , focus: true
    describe '- profile events ' do
      #     {type_number: 4, name: 'создание профиля'},
      #     {type_number: 5, name: 'переименование'},
      #     {type_number: 6, name: 'удаление'},
      let(:profile_event_data) {{
              event_type: 4,
              user_id: 57,
              email: "zoneiva@gmail.com",
              profile_id: 790,
              user_profile_data: "Aleksey",
              agent_profile_id: 799,
              agent_profile_data: "Anna"
            }}

      # let(:one_event_row) { Event.profile_event(profile_event_data) }

      context '- profile_event(profile_event_data) - On create - ' do
        before { Event.profile_event(profile_event_data) }
        it "- Make proper event row after Event.profile_event: " do
          puts "Event 'create profile' Method 'profile_event' check:
                profile_event_data = #{profile_event_data}"
          puts "Event 'create profile' Method 'profile_event' check:
                Event.all.count = #{Event.all.count}\n"
          event_fields = Event.first.attributes.except('created_at','updated_at')
          expect(event_fields).to eq({"id"=>1, "event_type"=>4, "read"=>false, "user_id"=>57,
                                      "email"=>"zoneiva@gmail.com", "profile_id"=>790,
                                      "user_profile_data"=>"Aleksey", "agent_user_id"=>nil, "agent_profile_id"=>799,
                                      "agent_profile_data"=>"Anna", "profiles_qty"=>nil,
                                      "log_type"=>nil, "log_id"=>nil})
        end


      end

    end

  end
end
