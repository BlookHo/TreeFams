module ApplicationHelper


  def circle_path_helper(current_path, profile_id, relation_id)
    if current_path.blank?
      return profile_id.to_s+','+relation_id.to_s
    else
      current_path + '-' + profile_id.to_s+','+relation_id.to_s
    end
  end

  # prefix 1 - Ваш(а)
  #
  def relation_to_human(id, prefix: false)
    return '' if id.nil?
    case id.to_i
    when  0
      prefix ? "Вы" : "Автор"
    when  1
      prefix ? "Ваш отец" : "Отец"
    when  2
      prefix ? "Ваша мать" : "Мать"
    when  3
      prefix ? "Ваш сын" : "Сын"
    when 4
      prefix ? "Ваша дочь" : "Дочь"
    when  5
      prefix ? "Ваш Брат" : "Брат"
    when  6
      prefix ? "Ваша сестра" : "Сестра"
    when  7
      prefix ? "Ваш муж" : "Муж"
    when 8
      prefix ? "Ваша жена" : "Жена"
    when 9
        prefix ? "Ваш дед" : "Дед"
    when 10
        prefix ? "Ваша бабка" : "Бабка"
    when 11
        prefix ? "Ваш внук" : "Внук"
    when 12
        prefix ? "Ваша внучка" : "Внучка"
    else
      "Неизвестно"
    end
  end

  # Получает хеш {profile_id => relation_id}
  # какое отношенеи к какому профилю
  def relation_to_profile(data)
    return '' if data.nil?
    if data.keys.first == current_user.profile_id
      relation_to_human(data.values.first, prefix: true)
    else
      [relation_to_human(data.values.first), YandexInflect.inflections(Profile.find( data.keys.first ).full_name)[1]["__content__"] ].join(' ')
    end
  end


  def sex_id_to_human(sex_id)
    if sex_id and sex_id == 0
      return 'eё'
    elsif sex_id and sex_id == 1
      return 'его'
    else
      return nil
    end
  end


end
