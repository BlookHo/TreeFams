require 'rails_helper'

RSpec.describe UpdatesFeed, type: :model  do # , focus: true

  describe '- validation' do
    describe '- on create' do

      context '- valid updates_feed row' do
        let(:updates_feed_row) {FactoryGirl.build(:updates_feed)}  #
        it '- saves a valid updates_feed row' do
          puts "Model UpdatesFeed validation "
          expect(updates_feed_row).to be_valid
        end
      end

      context '- invalid updates_feed row' do
        let(:bad_user) {FactoryGirl.build(:updates_feed, :uncorrect_user)}
        it '- 1 Dont save: - bad_user - uninteger' do
          expect(bad_user).to_not be_valid
        end
        let(:bad_update_id) {FactoryGirl.build(:updates_feed, :uncorrect_update_id)}
        it '- 2 Dont save: - bad_update_id - uninteger' do
          expect(bad_update_id).to_not be_valid
        end
        let(:bad_uncorrect_agent_user) {FactoryGirl.build(:updates_feed, :uncorrect_agent_user_id)}
        it '- 3 Dont save: - bad_uncorrect_agent_user - uninteger' do
          expect(bad_uncorrect_agent_user).to_not be_valid
        end
        let(:bad_uncorrect_agent_profile) {FactoryGirl.build(:updates_feed, :uncorrect_agent_profile_id)}
        it '- 4 Dont save: - agent_profile - uninteger' do
          expect(bad_uncorrect_agent_profile).to_not be_valid
        end
        let(:bad_uncorrect_who_made_event) {FactoryGirl.build(:updates_feed, :uncorrect_who_made_event)}
        it '- 4 Dont save: - who_made_event - uninteger' do
          expect(bad_uncorrect_who_made_event).to_not be_valid
        end
        let(:bad_uncorrect_read) {FactoryGirl.build(:updates_feed, :uncorrect_read)}
        it '- 5 Dont save: - bad_uncorrect_read - not boolean' do
          expect(bad_uncorrect_read).to_not be_valid
        end
        let(:bad_uncorrect_user_and_agent_user) {FactoryGirl.build(:updates_feed, :uncorrect_user_and_agent_user)}
        it '- 6 Dont save: - bad_user_and_agent_user - equal' do
          expect(bad_uncorrect_user_and_agent_user).to_not be_valid
        end

      end

    end
  end

end