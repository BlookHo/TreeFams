module SimilarsExclusions
  extend ActiveSupport::Concern
  # in User model

  module ClassMethods
    ######################################################################
    # МЕТОДЫ ПРОВЕРКИ УСЛОВИЯ ИСКЛЮЧЕНИЯ ПОХОЖЕСТИ
    ######################################################################
    # Метод определения факта исключения похожести двух профилей.
    # Независимо от мощноти общности их кругов
    # На основе проверки существования отношений исключения похожести
    # в необщих частях 2-х кругов.
    def check_similars_exclusions(data_for_check)
      logger.info "*** In check_similars_exclusions 1: data_for_check: #{data_for_check}"
      uncommon_hash_a, uncommon_hash_b = get_uncommons(data_for_check[:a_profile_circle], data_for_check[:b_profile_circle], data_for_check[:common_hash])
      inter_relations = common_of_uncommons(uncommon_hash_a, uncommon_hash_b)
      sim_exlude_relations = [ "Отец", "Мама", "Дед-о", "Дед-м", "Бабка-о","Бабка-м"   ] # ++ "Отец",
      # todo: поместить и брать массив exlude_relations из таблицы WeafamSettings
      unsimilar_sign = check_relations_exclusion(inter_relations, sim_exlude_relations)
      logger.info "*** In check_similars_exclusion 78: unsimilar_sign: #{unsimilar_sign}, inter_relations: #{inter_relations}"
      return unsimilar_sign, inter_relations
    end

    # get_uncommons
    # Получение не общих частей кругов профилей а и б
    def get_uncommons(a_profile_circle, b_profile_circle, common_hash)
      uncommon_hash_a = unintersection(a_profile_circle, common_hash)
      uncommon_hash_b = unintersection(b_profile_circle, common_hash)
      #logger.info "*** In get_uncommons 74: uncommon_hash_a: #{uncommon_hash_a}"
      #logger.info "*** In get_uncommons 75: uncommon_hash_b: #{uncommon_hash_b}"
      return uncommon_hash_a, uncommon_hash_b
    end

    # get_commons_of_uncommons relations
    # Получение пересечения (общей части) не общих частей кругов профилей а и б
    def common_of_uncommons(uncommon_hash_a, uncommon_hash_b)
      relations_a = uncommon_hash_a.keys
      relations_b = uncommon_hash_b.keys
      inter_relations = relations_a & relations_b
      #logger.info "*** In common_of_uncommons 76: inter_relations: #{inter_relations}"
      inter_relations
    end
    # check relations exclusion
    # Установка значения признака в завис-ти от того, существуют ли среди пересечения inter_relations необщих частей кругов
    # двух профилей а и б какие-либо из отношений, входящие в массив Отношений-Исключений = exlude_relations.
    # Если существует, значит среди пересечения необщих частей кругов есть отношения Отец, Мать, Дед, Бабка.
    # Наличие таких отношений, которые тем не менее не совпали по именам, говорит о том, что эти 2 профиля -
    # разные люди. Следовательно, нет необходимости далее вычислять мощность общности общей части.
    def check_relations_exclusion(inter_relations, exlude_relations)
      unsimilar_sign = true # Исх.знач-е
      inter_relations.each do |relation|
        unsimilar_sign = false if exlude_relations.include?(relation) # Значит - точно непохожие
        logger.info "*** In check_rels_ each 77-1: relation: #{relation}, exlude_relations.include?(relation) = #{exlude_relations.include?(relation)}, exlude_relations = #{exlude_relations} "
        logger.info "*** In check_relations_exclusion 77-2: unsimilar_sign: #{unsimilar_sign}"
      end
      #logger.info "*** In check_relations_exclusion 77: unsimilar_sign: #{unsimilar_sign}"
      unsimilar_sign  # передача значения признака (true/false)
    end

    # todo: перенести этот метод в Operational - для нескольких моделей
    # пересечение 2-х хэшей, у которых - значения = массивы
    def unintersection(first, other)
      result = {}
      first.reject { |k, v| (other.include?(k)) }.each do |k, v|
        # intersect = other[k] & v
        result.merge!({k => v}) #if !intersect.blank?
      end
      result
    end


  end

end