module ApplicationHelper

  def relation_to_human(id)
    case id.to_i
    when  0
      "Автор (это Вы)"
    when  1
      "Отец"
    when  2
      "Мать"
    when  3
      "Cын"
    when 4
      "Дочь"
    when  5
      "Брат"
    when  6
      "Сестра"
    when  7
      "Муж"
    when 8
      "Жена"
    else
      "Неизвестно"
    end
  end
end
