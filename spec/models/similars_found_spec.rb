require 'rails_helper'

RSpec.describe SimilarsFound, :type => :model do
  #pending "add some examples to (or delete) #{__FILE__}"

  describe 'validation' do
    describe 'on create' do

      context 'Valid similars pair' do

        let(:good_similars_found) {FactoryGirl.build(:similars_found)}
        it 'Saves a valid similars pair' do
          expect(good_similars_found).to be_valid
        end

        let(:good_similars_found_2) {FactoryGirl.build(:similars_found, :big_IDs)}
        it 'Saves a valid similars pair - big IDs' do
          expect(good_similars_found_2).to be_valid
        end
      end

      context 'Invalid similars pairs' do
        let(:bad_similars_found_1) {FactoryGirl.build(:similars_found, :user_id_nil)}
        it 'Does not save an invalid similars pair - user_id_nil' do
          expect(bad_similars_found_1).to_not be_valid
        end

        let(:bad_similars_found_2) {FactoryGirl.build(:similars_found, :ids_equal)}
        it 'Does not save an invalid similars pair - equal Profile_IDs' do
          expect(bad_similars_found_2).to_not be_valid
        end

        let(:bad_similars_found_3) {FactoryGirl.build(:similars_found, :one_id_less_zero)}
        it 'Does not save an invalid similars pair - one_id_less_zero' do
          expect(bad_similars_found_3).to_not be_valid
        end

        let(:bad_similars_found_4) {FactoryGirl.build(:similars_found, :other_id_less_zero)}
        it 'Does not save an invalid similars pair - other_id_less_zero' do
          expect(bad_similars_found_4).to_not be_valid
        end

        let(:bad_similars_found_5) {FactoryGirl.build(:similars_found, :one_id_Uninteger)}
        it 'Does not save an invalid similars pair - one_id_Uninteger' do
          expect(bad_similars_found_5).to_not be_valid
        end
      end

      # context 'Invalid similars pairs' do
      #   let(:user) {FactoryGirl.build(:user, :wrong_id_less_zero)}
      #
      #   it 'does not save an invalid similars pair - equal IDs' do
      #     # name = user.name
      #     # user.update_name
      #     # expect(name).to_not eq(user.name)
      #     expect(user).to_not be_valid
      #   end
      # end

    end

  end


  describe 'model methods' do
    pending "making test SimilarsFound methods in #{__FILE__}"
    # before(:all) do
    #   @similars_found = SimilarsFound.new( email: "new@nn.nn", password: '1111', profile_id:  1)
    #   @similars_found.save
    #   @user_profile = @user.profile_id
    # end

    # [{:first_profile_id=>38, :first_relation_id=>"Жена", :name_first_relation_id=>"Петра", :first_name_id=>"Ольга", :first_sex_id=>"Ж",
    #   :second_profile_id=>42, :second_relation_id=>"Сестра", :name_second_relation_id=>"Елены", :second_name_id=>"Ольга", :second_sex_id=>"Ж",
    #   :common_relations=>{"Отец"=>[351], "Мама"=>[187], "Сестра"=>[173], "Муж"=>[370]}, :common_power=>4, :inter_relations=>[]},
    #  {:first_profile_id=>44, :first_relation_id=>"Мама", :name_first_relation_id=>"Ольги", :first_name_id=>"Жанна", :first_sex_id=>"Ж",
    #   :second_profile_id=>43, :second_relation_id=>"Жена", :name_second_relation_id=>"Олега", :second_name_id=>"Жанна", :second_sex_id=>"Ж",
    #   :common_relations=>{"Дочь"=>[173, 354], "Муж"=>[351]}, :common_power=>3, :inter_relations=>[]},
    #  {:first_profile_id=>41, :first_relation_id=>"Отец", :name_first_relation_id=>"Елены", :first_name_id=>"Олег", :first_sex_id=>"М",
    #   :second_profile_id=>40, :second_relation_id=>"Отец", :name_second_relation_id=>"Ольги", :second_name_id=>"Олег", :second_sex_id=>"М",
    #   :common_relations=>{"Дочь"=>[173, 354], "Жена"=>[187], "Зять"=>[370]},
    #   :common_power=>4, :inter_relations=>[]},
    #  {:first_profile_id=>39, :first_relation_id=>"Сестра", :name_first_relation_id=>"Ольги", :first_name_id=>"Елена", :first_sex_id=>"Ж",
    #   :second_profile_id=>35, :second_relation_id=>"Жена", :name_second_relation_id=>"Андрея", :second_name_id=>"Елена", :second_sex_id=>"Ж",
    #   :common_relations=>{"Отец"=>[351], "Мама"=>[187], "Сестра"=>[354]}, :common_power=>3, :inter_relations=>[]}]

    # describe 'find_stored_similars' do
    #   similars =
    #   current_user_id =
    #   previous_similars, new_similars = SimilarsFound.find_stored_similars(similars, current_user_id)
    #
    #
    # end
  end



end
