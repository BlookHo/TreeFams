class ExtraCode

  # Ввод одного профиля древа. Проверка Имя-Пол.
  # @note GET /
  # @param admin_page [Integer] опциональный номер страницы
  # @see Place
  def enter_profile_bk(profile_name)    # NO USE
    # проверка, действ-но ли введено женское имя?
    if !profile_name.blank?
      if !check_sex_by_name(profile_name)
        name_correct = true
      else
        name_correct = false
      end
    end
    return name_correct
  end




end