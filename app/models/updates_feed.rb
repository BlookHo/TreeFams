class UpdatesFeed < ActiveRecord::Base

  validates_presence_of :user_id, :update_id, :message => "Должно присутствовать в UpdatesFeed"
  validates_numericality_of :user_id, :update_id, :only_integer => true, :message => "ID автора нового события и ID события должны быть целым числом в UpdatesFeed"
  validates_numericality_of :user_id, :update_id, :greater_than => 0, :message => "ID автора нового события и ID события должны быть больше 0 в UpdatesFeed"
  validates_inclusion_of :read, :in => [true, false]


  # Выбираем те обновления, кот. относятся к дереву, в котором сидит current_user,
  # т.е. сгенерированные членами твоего дерева (и избранными тобой профилями-юзерами)
  # Но без созданных тобой - т.е. без current_user
  # Упорядочены по дате создания - сначала самые свежие
  # в SQL-запрос включаются те обновления, в кот-х в кач-ве agent_user_id - члены дерева current_user
  # Это обновления связ. с запросами на объединения
  # Дурацкая запись SQL запроса из-за OR
  def self.select_updates(current_user)
    connected_users = current_user.get_connected_users
    logger.info "In select_updates: connected_users = #{connected_users}" #
    if !connected_users.blank?
      updates_feeds = UpdatesFeed.where("user_id in (?) or agent_user_id  in (?)", connected_users, connected_users ).where.not(user_id: current_user.id).order('created_at').reverse_order
      logger.info "In select_updates: updates_feeds.size = #{updates_feeds.size}"
      UpdatesFeed.create_view_data(read_updates(updates_feeds))
    end
  end

  # Пометка отображенных обновлений как прочитанные
  # для подсвечивания в View.
  def self.read_updates(updates_feeds)
    updates_feeds.each do |one_update|
      one_update.read = true
      one_update.save
      #logger.info "In read_updates: save: one_update.read = #{one_update.read} "
    end
  end

  # Создание массива для отображения обновлений для View
  def self.create_view_data(updates_feeds)
    view_update_data = []
    updates_feeds.each do |updates_feed|
      view_update_data << UpdatesFeed.collect_one_update_data(updates_feed) if !updates_feed.blank?
    end
    return view_update_data
  end

  # Создание одного хэша - элемента массива для отображения обновлений для View
  def self.collect_one_update_data(updates_feed)
    update_data = Hash.new
    update_data[:user_update_author] = updates_feed.user_update_data(updates_feed.user_id)[:user_name]
    update_data[:user_author_email]  = updates_feed.user_update_data(updates_feed.user_id)[:user_email]
    update_data[:update_text]        = updates_feed.update_event_data(updates_feed.update_id)[:text]

    #  Если в данном виде обновления профиль-агент не используется, то во View - ничего не показываем
    update_data[:agent_in_update]    = updates_feed.fill_agent_field(updates_feed) if !updates_feed.agent_user_id.blank?

    update_data[:update_read]        = updates_feed.read
    update_data[:update_image]       = updates_feed.update_event_data(updates_feed.update_id)[:image]
    update_data[:update_created]     = updates_feed.read_datatime_created(updates_feed)

    return update_data
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
    { user_name: get_name(user.profile_id), user_email: user.email }
  end

  # Извлечение имени профиля
  def get_name(profile_id)
    Name.find(Profile.find(profile_id).name_id).name
  end

  # Чтение значения поля created_at для показа в View в нужном формате
  def read_datatime_created(updates_feed)
    (updates_feed.read_attribute_before_type_cast(:created_at)).to_datetime.strftime('%d.%m.%Y в %k:%M:%S')
  end

  # Заполнение Именем agent_user_id поля agent_in_update для отображения
  # в случае когда agent_user_id - user
  # ИЛИ
  # в случае когда agent_user_id - profile
  def fill_agent_field(updates_feed)

      case updates_feed.update_id
        when 1, 2 # запросы на объединение, объединения   ИЛИ
          # ConnectionRequestsController, ConnectUsersTreesController
          updates_feed.user_update_data(updates_feed.agent_user_id)[:user_name]

        when 3, 4, 5  # избранный профиль -       ИЛИ
          # добавлен профиль - ProfilesController  ИЛИ
          # приглашение на сайт по почте -  InvitesController
          get_name(updates_feed.agent_user_id)

        when 6  # изменились данные профиля

        when 7  # семейное событие в дереве

        when 8, 9, 10  # кол-во родни в дереве больше 25, 50, 100... - ProfilesController
          get_name(updates_feed.agent_user_id)

        else
          nil
      end

  end


  #UpdatesFeed.last.elol

  #def elol
  #  "5"
  #end



end
