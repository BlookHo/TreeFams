class UpdatesFeed < ActiveRecord::Base

  validates_presence_of :user_id, :update_id, :agent_user_id, :agent_profile_id, :who_made_event,
                        :message => "Должно присутствовать в UpdatesFeed"
  validates_numericality_of :user_id, :update_id, :agent_user_id, :agent_profile_id, :who_made_event, :only_integer => true,
                            :message => "ID автора нового события и ID события должны быть целым числом в UpdatesFeed"
  validates_numericality_of :user_id, :update_id, :agent_user_id, :agent_profile_id, :who_made_event, :greater_than => 0,
                            :message => "ID автора нового события и ID события должны быть больше 0 в UpdatesFeed"
  validates_inclusion_of :read, :in => [true, false], :message => "Должны быть в [true, false] в UpdatesFeed"
  # validate :updates_fields_not_equal  # :user_id  AND :agent_user_id

  # custom validation
  # def updates_fields_not_equal
  #   self.errors.add(:updates_feeds, 'Fields в одном ряду не должны быть равны в UpdatesFeed.') if self.agent_profile_id == self.agent_user_id
  # end


  belongs_to :user

  # @note: Выбираем те обновления, кот. относятся к дереву, в котором сидит current_user,
  # т.е. сгенерированные членами твоего дерева (и избранными тобой профилями-юзерами)
  # Но без созданных тобой - т.е. без current_user
  # Упорядочены по дате создания - сначала самые свежие
  # в SQL-запрос включаются те обновления, в кот-х в кач-ве agent_user_id - члены дерева current_user
  # Это обновления связ. с запросами на объединения
  # Дурацкая запись SQL запроса из-за OR
  def self.select_updates(current_user)
    connected_users = current_user.get_connected_users
    # logger.info "In select_updates: connected_users = #{connected_users}" #
    unless connected_users.blank?
      updates_feeds = UpdatesFeed.where("user_id in (?) or agent_user_id  in (?)", connected_users, connected_users )
                          .where.not(user_id: current_user.id).order('created_at').reverse_order
      # logger.info "In select_updates: updates_feeds.size = #{updates_feeds.size}"
      UpdatesFeed.make_view_data(read_updates(updates_feeds), current_user.id)
    end
  end


  # @note:  Пометка отображенных обновлений как прочитанные
  #  для подсвечивания в View.
  def self.read_updates(updates_feeds)
    updates_feeds.each do |one_update|
      one_update.read = true
      one_update.save
    end
  end

  # @note:  Создание массива для отображения обновлений для View
  def self.make_view_data(updates_feeds, current_user_id)
    view_update_data = []
    updates_feeds.each do |updates_feed|
      new_update = UpdatesFeed.collect_one_update_data(updates_feed, current_user_id) unless updates_feed.blank?
      view_update_data << new_update unless UpdatesFeed.check_skip_updates_feed(view_update_data, new_update)    # == false
    end
    view_update_data
  end

  # @note: Проверка текущего обновления:
  #   если такое точно уже было ( для типа 2 и 17 - объединение/разъединение)
  #   то не включаем его в массив отображения
  def self.check_skip_updates_feed(view_update_data, new_update)
    skip = false
    view_update_data.each do |update_in_array|
      skip = true if
              new_update[:update_text] == update_in_array[:update_text] &&
              new_update[:update_created] == update_in_array[:update_created] &&
              (new_update[:update_id] == 17 or new_update[:update_id] == 2)
    end
    skip
  end



  # Создание одного хэша - элемента массива для отображения обновлений для View
  # update_data = Hash.new
  # # Show in View /index
  # update_data[:update_text]        = updates_feed.combine_update_text(updates_feed, current_user_id)
  # # Show in View /index
  # update_data[:update_created]     = updates_feed.read_datatime_created(updates_feed)
  #
  # # JUST NOW - Did not Show in View /index(later)
  # update_data[:update_id]         = updates_feed.update_id
  # update_data[:update_read]        = updates_feed.read
  # update_data[:update_image]       = updates_feed.update_event_data(updates_feed.update_id)[:image]
  def self.collect_one_update_data(updates_feed, current_user_id)
    update_data = { update_text:    updates_feed.combine_update_text(updates_feed, current_user_id), # Show in View /index
                    update_created: updates_feed.read_datatime_created(updates_feed), # Show in View /index
                    update_id:      updates_feed.update_id, # Does not Show in View /index(later)
                    update_read:    updates_feed.read, # Does not Show in View /index(later)
                    update_image:   updates_feed.update_event_data(updates_feed.update_id)[:image] # Does not Show in View /index(later)
    }
    update_data
  end

  # Извлечение данных о типовых событиях-обновлениях для одного обновления для View
  def update_event_data(updates_feed_id)
    one_update = UpdatesEvent.find(updates_feed_id)
    { text: one_update.name, image: one_update.image }
  end

  # Извлечение данных для User из одного обновления для View
  # Заполнение Именем agent_user_id поля agent_in_update для отображения
  # в случае когда agent_user_id - user
  def user_update_data(user_id)
    user = User.find(user_id)
    # { user_name: get_name(user.profile_id), user_email: user.email }
    { user_name: user.profile.to_name, user_email: user.email }
  end

  # Извлечение имени профиля
  def get_name(profile_id)
    profile = Profile.where(id: profile_id).first
    profile.nil? ? "Merged profile" : profile.to_name
    #name_id = profile.name_id
    #Name.find(name_id).name
    # Name.find(Profile.find(profile_id).name_id).name
  end

  # Чтение значения поля created_at для показа в View в нужном формате
  def read_datatime_created(updates_feed)
    (updates_feed.read_attribute_before_type_cast(:created_at)).to_datetime.strftime('%d.%m.%Y в %k:%M:%S')
  end

  # Формирование полного связного текста каждого из сообщений updates_feed
  def combine_update_text(updates_feed, current_user_id)

    text_data = updates_feed.get_text_data(updates_feed)
    prefix, suffix = ""
    # todo: similars
    case updates_feed.update_id # по типу UpdatesEvent
      when 1 # запросы на объединение in ConnectionRequestsController  # OK
        prefix, suffix = updates_feed.combine_1_text(updates_feed, text_data, current_user_id)
      when 2, 17 # объединения/разъединение дереве in ConnectionTrees.rb & DisconnectionTrees.rb  # OK
        prefix, suffix = updates_feed.combine_2_17_text(updates_feed, text_data, current_user_id)
      when 3  # избранный профиль -
        prefix, suffix = updates_feed.combine_3_text(updates_feed, text_data)
      when 4, 18  # добавлен профиль in ProfilesController   # OK
        prefix, suffix = updates_feed.combine_4_18_text(updates_feed, text_data)
      when 5  # приглашение на сайт по почте in InvitesController   # OK
        prefix, suffix = updates_feed.combine_5_text(updates_feed, text_data)

      when 6  # изменились данные профиля - To be defined later
      when 7  # семейное событие в дереве - To be defined later

      when 8 .. 16 # изменилось кол-во родни в объединенном дереве   # OK
                  # в рез-те добавления профиля или объединения деревьев in ProfilesController, ConnectUsersTreesController
        prefix, suffix = updates_feed.combine_8__16_text(updates_feed, current_user_id)
      when 19, 20 # объединения/разъединение similars in SimConnectionTrees.rb & SimDisconnectionTrees.rb  #
        prefix, suffix = updates_feed.combine_19_20_text(updates_feed, text_data, current_user_id)
      else
        logger.info "ERROR In combine_update_text: Undefined updates_feed.update_id = #{updates_feed.update_id}"

    end
    prefix + text_data[:event_text] + suffix

  end

  # Сбор данных для формирования текста updates_feed
  def get_text_data(updates_feed)
    text_data = Hash.new
    text_data[:author_name] = updates_feed.user_update_data(updates_feed.user_id)[:user_name]
    text_data[:who_made_event_name] = updates_feed.user_update_data(updates_feed.who_made_event)[:user_name]
    text_data[:event_text] = updates_feed.update_event_data(updates_feed.update_id)[:text]

    text_data
  end

  # Формирование итоговой текстовой фразы одного сообщения updates_feed
  # для UpdatesEvent типа 1 запросы на объединение
  def combine_1_text(updates_feed, text_data, current_user_id)

    !updates_feed.agent_user_id.blank? ? text_data[:agent_name] = updates_feed.user_update_data(updates_feed.agent_user_id)[:user_name] : text_data[:agent_name] = ""
    text_data[:author_name] != "" ? suffix = text_data[:author_name] : suffix = ""
    updates_feed.agent_user_id == current_user_id ? prefix = text_data[:agent_name] + '! Тебе' : prefix = 'Твоему родственнику ' + inflect_name(text_data[:agent_name], 2)

    return prefix, suffix
  end


  # @note:  Формирование итоговой текстовой фразы одного сообщения updates_feed
  #   для UpdatesEvent типа 2 и 17:
  def combine_2_17_text(updates_feed, text_data, current_user_id)

    !updates_feed.agent_user_id.blank? ? text_data[:agent_name] = updates_feed.user_update_data(updates_feed.agent_user_id)[:user_name] : text_data[:agent_name] = ""
    current_user_name =  updates_feed.user_update_data(current_user_id)[:user_name]
    updates_feed.update_id == 2 ? greeting = 'Поздравляем, ' : greeting = 'Внимание, '

    if current_user_id == updates_feed.who_made_event
      prefix = greeting + current_user_name  + '! ' + 'Тобой'
      suffix = ' с деревом твоего родственника по имени ' + text_data[:author_name]
    else
      prefix = greeting + current_user_name  + '! ' + 'Пользователем по имени ' + text_data[:who_made_event_name]
      suffix = ' твоего дерева'
    end

    return prefix, suffix
  end

  # @note:  Формирование итоговой текстовой фразы одного сообщения updates_feed
  #   для UpdatesEvent типа 2 и 17:
  def combine_19_20_text(updates_feed, text_data, current_user_id)

    !updates_feed.agent_user_id.blank? ? text_data[:agent_name] = updates_feed.user_update_data(updates_feed.agent_user_id)[:user_name] : text_data[:agent_name] = ""
    current_user_name =  updates_feed.user_update_data(current_user_id)[:user_name]
    # updates_feed.update_id == 2 ? greeting = 'Поздравляем, ' :
    greeting = 'Внимание, '
    if current_user_id == updates_feed.who_made_event
      prefix = greeting + current_user_name  + '! ' + 'Тобой'
      suffix = ' с деревом твоего родственника по имени ' + text_data[:author_name]
    else
      prefix = greeting + current_user_name  + '! ' + 'Пользователем по имени ' + text_data[:who_made_event_name]
      suffix = ' твоего дерева'
    end

    return prefix, suffix
  end



  # Формирование итоговой текстовой фразы одного сообщения updates_feed
  # для UpdatesEvent типа 3 избранный профиль
  def combine_3_text(updates_feed, text_data)
    !updates_feed.agent_user_id.blank? ? text_data[:agent_name] = updates_feed.get_name(updates_feed.agent_profile_id) : text_data[:agent_name] = ""
    text_data[:agent_name] != "" ? suffix = text_data[:agent_name] : suffix = ""
    prefix = 'Твой родственник ' + text_data[:author_name]
    return prefix, suffix
  end

  # Формирование итоговой текстовой фразы одного сообщения updates_feed
  # для UpdatesEvent типа 4 добавлен профиль
  def combine_4_18_text(updates_feed, text_data)

    !updates_feed.agent_user_id.blank? ? text_data[:agent_name] = updates_feed.get_name(updates_feed.agent_profile_id) : text_data[:agent_name] = ""
    prefix = 'Твоим родственником ' + inflect_name(text_data[:author_name],4)
    text_data[:agent_name] != "" ? suffix = text_data[:agent_name] : suffix = ""

    return prefix, suffix
  end

  # Формирование итоговой текстовой фразы одного сообщения updates_feed
  # для UpdatesEvent типа 5 приглашение на сайт
  def combine_5_text(updates_feed, text_data)

    !updates_feed.agent_user_id.blank? ? text_data[:agent_name] = updates_feed.get_name(updates_feed.agent_profile_id) : text_data[:agent_name] = ""
    text_data[:agent_name] != "" ? suffix = text_data[:agent_name] : suffix = ""
    prefix = 'Твоим родственником ' + inflect_name(text_data[:author_name],4)

    return prefix, suffix
  end

  # Формирование итоговой текстовой фразы одного сообщения updates_feed
  # для UpdatesEvent типа 8___16  изменилось кол-во родни
  def combine_8__16_text(updates_feed, current_user_id)

    prefix = 'Поздравляем, ' + updates_feed.user_update_data(current_user_id)[:user_name] + '!'
    suffix = ""

    return prefix, suffix
  end

  # Склонение имени по падежу == padej
  def inflect_name(text_data_name, padej)
    text_data_name != "" ? inflected_name = YandexInflect.inflections(text_data_name)[padej]["__content__"] : inflected_name = ""
    inflected_name
  end


  # Перезапись profile_id при объединении деревьев
  # в модели UpdatesFeed
  #
  def self.connect_update_profiles(profiles_to_rewrite, profiles_to_destroy)
    updates_to_connect = self.where("agent_profile_id in (?) ", profiles_to_destroy)
    profiles_to_destroy.each_with_index do |destroy_profile_id, index|
      updates_to_connect.each do |update_feed|
        if update_feed.agent_profile_id == destroy_profile_id
          update_feed.update_column(:agent_profile_id, profiles_to_rewrite[index])
        end
      end
    end

  end



end



