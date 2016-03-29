FactoryGirl.define do
  factory :event, class: Event do |f|
    f.event_type        2
    f.read              false
    f.user_id           { Faker::Number.number(5) }
    f.email             "MyString"
    f.profile_id        { Faker::Number.number(5) }
    f.user_profile_data "NextString"
    f.agent_user_id     { Faker::Number.number(5) }
    f.agent_profile_id  { Faker::Number.number(5) }
    f.agent_profile_data "Фамилия"
    f.profiles_qty      { Faker::Number.number(5) }
    f.log_type          { Faker::Number.number(5) }
    f.log_id            { Faker::Number.number(5) }
  end

  factory :event_common, class: Event do
    # CORRECT
    event_type  4
    read false
    user_id 1
    email "MyString"
    profile_id 17
    user_profile_data "NextString 12345"
    agent_user_id 2
    agent_profile_id 11
    agent_profile_data "~~~~~ Фамилия 12345"
    profiles_qty 21
    log_type 1
    log_id 12

    # validation
    trait :type_uncorrect do
      event_type  55
      # read false
      # user_id 1
      # email "MyString"
      # profile_id 1
      # user_profile_data "NextString 12345"
      # agent_user_id 1
      # agent_profile_id ""
      # agent_profile_data "~~~~~ Фамилия 12345"
      # profiles_qty 1
      # log_type 1
      # log_id 1
    end

    trait :profile_id_uncorrect do
      event_type  26
      read false
      # user_id 1
      # email "MyString"
      profile_id 0
      # user_profile_data "NextString 12345"
      # agent_user_id 1
      # agent_profile_id ""
      # agent_profile_data "~~~~~ Фамилия 12345"
      # profiles_qty 1
      # log_type 1
      # log_id 1
    end
    trait :agent_user_id_uncorrect do
      # event_type  26
      # read false
      # user_id 1
      # email "MyString"
      profile_id 10
      # user_profile_data "NextString 12345"
      agent_user_id -10
      # agent_profile_id ""
      # agent_profile_data "~~~~~ Фамилия 12345"
      # profiles_qty 1
      # log_type 1
      # log_id 1
    end




  end

end
