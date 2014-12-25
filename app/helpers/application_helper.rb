module ApplicationHelper


  def json_string_to_hash(string)
    JSON.parse string.to_json.gsub('=>', ':')
  end


  # def prepare_data(data)
  #   proc = Proc.new { |k, v| v.kind_of?(Hash) ? (v.delete_if(&proc); nil) : v.blank? };
  #   data.delete_if(&proc)
  # end


  # def circle_path_helper(current_path, profile_id, relation_id)
  #   if current_path.blank?
  #     return profile_id.to_s+','+relation_id.to_s
  #   else
  #     current_path + '-' + profile_id.to_s+','+relation_id.to_s
  #   end
  # end

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
    when 91
        prefix ? "Ваш дед по Отцу" : "Дед по Отцу"
    when 92
      prefix ? "Ваш дед по Матери" : "Дед по Матери"
    when 101
        prefix ? "Ваша бабка по Отцу" : "Бабка по Отцу"
    when 102
      prefix ? "Ваша бабка по Матери" : "Бабка по Матери"
    when 111
        prefix ? "Ваш внук по Отцу" : "Внук по Отцу"
    when 112
      prefix ? "Ваш внук по Матери" : "Внук по Матери"
    when 121
      prefix ? "Ваша внучка по Отцу" : "Внучка по Отцу"
    when 122
      prefix ? "Ваша внучка по Матери" : "Внучка по Матери"
      when 13
        prefix ? "Ваш свекр" : "Свекр"
      when 14
        prefix ? "Ваша свекровь" : "Свекровь"
      when 15
        prefix ? "Ваш тесть" : "Тесть"
      when 16
        prefix ? "Ваша теща" : "Теща"
      when 17
        prefix ? "Ваш невестка" : "Невестка"
      when 18
        prefix ? "Ваш зять" : "Зять"
    when 191
      prefix ? "Ваш дядя по Отцу" : "Дядя по Отцу"
    when 192
      prefix ? "Ваш дядя по Матери" : "Дядя по Матери"
    when 201
      prefix ? "Ваша тетя по Отцу" : "Тетя по Отцу"
    when 202
     prefix ? "Ваша тетя по Матери" : "Тетя по Матери"
    when 211
      prefix ? "Ваш племянник по Отцу" : "Племянник по Отцу"
    when 212
      prefix ? "Ваш племянник по Матери" : "Племянник по Матери"
    when 221
      prefix ? "Ваша племянница по Отцу" : "Племянница по Отцу"
    when 222
      prefix ? "Ваша племянница по Матери" : "Племянница по Матери"
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
