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
    else
      "Неизвестно"
    end
  end
end
