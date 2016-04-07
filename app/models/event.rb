class Event < ActiveRecord::Base


  #############################################################
  # Иванищев А.В. 2016
  # Лента событий
  #############################################################

  validates_presence_of :event_type, :user_id, :email, :profile_id, :user_profile_data,
                         # :agent_user_id, #:agent_profile_id, :agent_profile_data, :profiles_qty,
                        # :log_type, :log_id,
                        :message => "Должно присутствовать в Event"
  validates_numericality_of :user_id, :profile_id, #:agent_user_id,
                             :agent_profile_id, #:log_type, #:log_id, #:profiles_qty,
                            :only_integer => true,
                            :message => "должны быть целым числом в Event"  #
  validates_numericality_of :user_id, :profile_id, # :agent_user_id,
                             :agent_profile_id, #:profiles_qty, #:log_type, :log_id,
                            :greater_than => 0,
                            :message => "должны быть больше 0 в Event"
  validates_inclusion_of :read, :in => [true, false], :message => "Должны быть в [true, false] в Event"
  validates_inclusion_of :event_type, :in => [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26],
                         :message => "Значение поля event_type должно быть in [event_types array] в Event"

  # validate :request_users_ids_not_equal  # :user_id  AND :with_user_id
  # # custom validation
  # def request_users_ids_not_equal
  #   self.errors.add(:connection_requests, 'Юзеры IDs в одном ряду не должны быть равны в Event.') if self.user_id == self.with_user_id
  # end

  # validates :name, format: { with: /\A[a-zA-Zа-яА-Я0-9]+\z/, message: "only allows letters and digits" }


  # @note: create profiles events
  #   profile_event_data = {
  #     event_type:
  #     email:
  #     user_id:
  #     profile_id:
  #     user_profile_data:
  #     agent_profile_id:
  #     agent_profile_data:
  #   }
  def self.profile_event(profile_event_data)
    # event_type = profile_event_data[:event_type]
    # user_id = profile_event_data[:user_id]
    # email = profile_event_data[:email]
    # profile_id = profile_event_data[:profile_id]
    # user_profile_data = profile_event_data[:user_profile_data]
    # agent_profile_id = profile_event_data[:agent_profile_id]
    # agent_profile_data = profile_event_data[:agent_profile_data]

    create(
            event_type:         profile_event_data[:event_type],
            user_id:            profile_event_data[:user_id],
            email:              profile_event_data[:email],
            profile_id:         profile_event_data[:profile_id],
            user_profile_data:  profile_event_data[:user_profile_data],
            agent_profile_id:   profile_event_data[:agent_profile_id],
            agent_profile_data: profile_event_data[:agent_profile_data],
            read:               false
            )


  end

  # todo:
  # @note: create profile data events
  def self.signup_event(signup_event_data)
    # event_type = profile_event_data[:event_type]
    # user_id = profile_event_data[:user_id]
    # email = profile_event_data[:email]
    # profile_id = profile_event_data[:profile_id]
    # user_profile_data = profile_event_data[:user_profile_data]
    # agent_profile_id = profile_event_data[:agent_profile_id]
    # agent_profile_data = profile_event_data[:agent_profile_data]

    create(
        event_type:         signup_event_data[:event_type],
        user_id:            signup_event_data[:user_id],
        email:              signup_event_data[:email],
        profile_id:         signup_event_data[:profile_id],
        user_profile_data:  signup_event_data[:user_profile_data],
        agent_profile_id:   signup_event_data[:agent_profile_id],
        agent_profile_data: signup_event_data[:agent_profile_data],
        read:               false
    )

  end


  # todo:
  # @note: create profile data events
  def self.login_logout_event(signup_event_data)
    # event_type = profile_event_data[:event_type]
    # user_id = profile_event_data[:user_id]
    # email = profile_event_data[:email]
    # profile_id = profile_event_data[:profile_id]
    # user_profile_data = profile_event_data[:user_profile_data]
    # agent_profile_id = profile_event_data[:agent_profile_id]
    # agent_profile_data = profile_event_data[:agent_profile_data]

    create(
        event_type:         signup_event_data[:event_type],
        user_id:            signup_event_data[:user_id],
        email:              signup_event_data[:email],
        profile_id:         signup_event_data[:profile_id],
        user_profile_data:  signup_event_data[:user_profile_data],
        agent_profile_id:   signup_event_data[:agent_profile_id],
        agent_profile_data: signup_event_data[:agent_profile_data],
        read:               false
    )

  end

  # todo:
  # @note: create invite events
  def self.invite_event(signup_event_data)
    # event_type = profile_event_data[:event_type]
    # user_id = profile_event_data[:user_id]
    # email = profile_event_data[:email]
    # profile_id = profile_event_data[:profile_id]
    # user_profile_data = profile_event_data[:user_profile_data]
    # agent_profile_id = profile_event_data[:agent_profile_id]
    # agent_profile_data = profile_event_data[:agent_profile_data]

    create(
        event_type:         signup_event_data[:event_type],
        user_id:            signup_event_data[:user_id],
        email:              signup_event_data[:email],
        profile_id:         signup_event_data[:profile_id],
        user_profile_data:  signup_event_data[:user_profile_data],
        agent_profile_id:   signup_event_data[:agent_profile_id],
        agent_profile_data: signup_event_data[:agent_profile_data],
        read:               false
    )

  end

  # todo:
  # @note: create connections events
  def self.connections_event(signup_event_data)
    # event_type = profile_event_data[:event_type]
    # user_id = profile_event_data[:user_id]
    # email = profile_event_data[:email]
    # profile_id = profile_event_data[:profile_id]
    # user_profile_data = profile_event_data[:user_profile_data]
    # agent_profile_id = profile_event_data[:agent_profile_id]
    # agent_profile_data = profile_event_data[:agent_profile_data]

    create(
        event_type:         signup_event_data[:event_type],
        user_id:            signup_event_data[:user_id],
        email:              signup_event_data[:email],
        profile_id:         signup_event_data[:profile_id],
        user_profile_data:  signup_event_data[:user_profile_data],
        agent_profile_id:   signup_event_data[:agent_profile_id],
        agent_profile_data: signup_event_data[:agent_profile_data],
        read:               false
    )

  end

  # todo:
  # @note: create similars_connections_event
  def self.similars_connections_event(signup_event_data)
    # event_type = profile_event_data[:event_type]
    # user_id = profile_event_data[:user_id]
    # email = profile_event_data[:email]
    # profile_id = profile_event_data[:profile_id]
    # user_profile_data = profile_event_data[:user_profile_data]
    # agent_profile_id = profile_event_data[:agent_profile_id]
    # agent_profile_data = profile_event_data[:agent_profile_data]

    create(
        event_type:         signup_event_data[:event_type],
        user_id:            signup_event_data[:user_id],
        email:              signup_event_data[:email],
        profile_id:         signup_event_data[:profile_id],
        user_profile_data:  signup_event_data[:user_profile_data],
        agent_profile_id:   signup_event_data[:agent_profile_id],
        agent_profile_data: signup_event_data[:agent_profile_data],
        read:               false
    )

  end


end
