class SimilarsFound < ActiveRecord::Base


  # Сохранение найденных пар похожих
  def self.store_similars(similars, current_user_id)

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

    sim_pairs = []
    similars.each do |one_sim_pair|
      one_sim_pair_data = { user_id: current_user_id,                               # int
                            first_profile_id: one_sim_pair[:first_profile_id],      # int
                            second_profile_id: one_sim_pair[:second_profile_id] }   # int
      sim_pairs<< self.new(one_sim_pair_data)
    end
    sim_pairs.each(&:save)  # store in table SimilarsFound
  end





end
