class Profile < ActiveRecord::Base

  # Аттрибуты при добавлении нового профиля
  attr_accessor :profile_name,
                :relation_id,
                :answers_hash

  # аттрибуты для контекстного меню
  attr_accessor :allow_add_relation,
                :allow_destroy,
                :allow_invite,
                :allow_conversation,
                :allow_rename
  # may be: attr_accessible instead attr_accessor

  include ProfileQuestions
  include ProfileMerge
  include ProfileApiCircles
  include SimilarsProfileMerge

  validates_presence_of :name_id, :tree_id, :deleted, :message => "Должно присутствовать в Profile"
  validates_inclusion_of :deleted, :in => [0, 1],
                         :message => ":deleted должно быть [0, 1] в Profile"
  validates_numericality_of :name_id, :tree_id,
                            :greater_than => 0, :message => "Должны быть больше 0 в Profile"
  validates_numericality_of :name_id,  :tree_id, :deleted,
                            :only_integer => true,  :message => "Должны быть целым числом в Profile"
  # validates_inclusion_of :sex_id, :in => [1,0], :message => "Должны быть [1,0] в Profile"
  validates_presence_of :user_id, :allow_nil => true
  validates_numericality_of  :user_id, :greater_than => 0, :only_integer => true, :allow_nil => true,
                             :message => "Должно быть целым числом больше 0 в Profile"

  has_one    :user
  has_one    :owner_user,
              primary_key: :tree_id,
              foreign_key: :id,
              class_name: User

  belongs_to :name
  belongs_to :display_name, class_name: Name, primary_key: :id, foreign_key: :display_name_id
  has_many   :trees

  has_one :profile_data, dependent: :destroy
  accepts_nested_attributes_for :profile_data


  # @note: rename one profile in this model
  def rename_in_profile(new_name_id)
    p "In model Profile - rename_in_profile:  profile_id = #{self.id}, new_name_id = #{new_name_id}"
    self.update_attributes(:name_id => new_name_id, updated_at: Time.now)
  end


  # @note: rename one profile in this model
  def rename(new_name_id)
    new_name = Name.find(new_name_id)
    p "In model Profile - rename: profile_id = #{self.id}, new_name_id = #{new_name_id}, new_name.sex_id = #{new_name.sex_id}"

    if new_name.sex_id == self.sex_id
      self.rename_in_profile(new_name_id)
      Tree.rename_in_tree(self.id, new_name_id)
      ProfileKey.rename_in_profile_key(self.id, new_name_id)
      puts "Профиль успешно переименован: с имени #{self.name_id} на имя #{new_name}."
      # render json: { status: 'ok', redirect: '/home' }
    else
      puts "Error:400 Выбрано имя не того пола, что Профиль: с имени #{self.name_id} на имя #{new_name}."
      # render json: { errors: @profile.errors.messages, redirect: '/home' }
      # render json: { errors: "Error:400 Выбрано имя не того пола, что Профиль", redirect: '/home' }
    end


  end





  # require 'pry'

  # before_save do
  #   puts "Before save"
  #   self.sex_id = name.try(:sex_id)
  #   # puts "self.sex_id = #{self.sex_id}"
  #   # binding.pry          # Execution will stop here.
  # end

  def to_name
    name.try(:name).try(:mb_chars).try(:capitalize)
  end

  def last_name
    profile_data.try(:last_name)
  end

  def middle_name
    profile_data.try(:middle_name)
  end

  def full_name
    [self.display_name.name].join(' ')
  end

  def icon_path
    self.name.sex_id == 1 ? '/assets/man.svg' : '/assets/woman.svg'
  end

  def avatar_path(size)
    avatars.empty? ? icon_path : avatars.first.avatar_url(size)
  end

  def avatars
    return []
  end


  # @note: получает на вход id деревьев из которых надо собрать ближний круг -
  #   using in make hashes in add_profile ProfileKey generation
  def circle(user_ids)
    ProfileKey.where(user_id: user_ids, profile_id: self.id, deleted: 0).order('relation_id').includes(:name).to_a.uniq(&:is_profile_id)
  end

  # На выходе ближний круг для профиля в дереве user_id
  # по записям в Tree
  def tree_circle(user_ids, profile_id)
    Tree.where(user_id: user_ids, profile_id: profile_id, deleted: 0).order('relation_id').includes(:name)
  end

  # На выходе - массив, аналогичный tree, который у нас сейчас формируется на старте.
  # [[ user_id, profile_id, name_id, relation_id , is_profile_id , is_name_id , is_sex_id  ]]
  def circle_as_array(user_id)
    circle(user_id).map {|t|  [t.user_id, t.profile_id, t.name_id, t.relation_id, t.is_profile_id, t.is_name_id, t.is_sex_id] }
  end


  def circle_as_hash(user_id)
    {
      author: {"profile_id" => self.id, "name_id" => self.name_id, "sex_id" => self.sex_id },
      mothers: mothers_hash(user_id),
      fathers: fathers_hash(user_id),
      sons: sons_hash(user_id),
      daughters: daughters_hash(user_id),
      brothers: brothers_hash(user_id),
      sisters: sisters_hash(user_id),
      husbands: husbands_hash(user_id),
      wives: wives_hash(user_id)
    }
  end


  def mothers(user_id)
    mothers = []
    circle(user_id).each do |m|
      mothers << m if m.relation_id == 2
    end
    return mothers
  end


  #  { profile_id => name_id, profile_id => name_id, ... }
  def mothers_hash(user_id)
    hash = {}
    mothers(user_id).each{|m| hash[m.is_profile_id] = m.is_name_id}
    return hash
  end


  def fathers(user_id)
    fathers = []
    circle(user_id).each do |m|
      fathers << m if m.relation_id == 1
    end
    return fathers
  end


  #  { profile_id => name_id, profile_id => name_id, ... }
  def fathers_hash(user_id)
    hash = {}
    fathers(user_id).each{|m| hash[m.is_profile_id] = m.is_name_id}
    return hash
  end


  def sons(user_id)
    sons = []
    circle(user_id).each do |m|
      sons << m if m.relation_id == 3
    end
    return sons
  end


  #  { profile_id => name_id, profile_id => name_id, ... }
  def sons_hash(user_id)
    hash = {}
    sons(user_id).each{|m| hash[m.is_profile_id] = m.is_name_id}
    return hash
  end



  def daughters(user_id)
    daughters = []
    circle(user_id).each do |m|
      daughters << m if m.relation_id == 4
    end
    return daughters
  end


  #  { profile_id => name_id, profile_id => name_id, ... }
  def daughters_hash(user_id)
    hash = {}
    daughters(user_id).each{|m| hash[m.is_profile_id] = m.is_name_id}
    return hash
  end


  def brothers(user_id)
    brothers = []
    circle(user_id).each do |m|
      brothers << m if m.relation_id == 5
    end
    return brothers
  end


  #  { profile_id => name_id, profile_id => name_id, ... }
  def brothers_hash(user_id)
    hash = {}
    brothers(user_id).each{|m| hash[m.is_profile_id] = m.is_name_id}
    return hash
  end


  def sisters(user_id)
    sisters = []
    circle(user_id).each do |m|
      sisters << m if m.relation_id == 6
    end
    return sisters
  end


  #  { profile_id => name_id, profile_id => name_id, ... }
  def sisters_hash(user_id)
    hash = {}
    sisters(user_id).each{|m| hash[m.is_profile_id] = m.is_name_id}
    logger.info "== in sisters_hash: hash = #{hash} "
    return hash
  end



  def husbands(user_id)
    husbands = []
    circle(user_id).each do |m|
      husbands << m if m.relation_id == 7
    end
    return husbands
  end


  #  { profile_id => name_id, profile_id => name_id, ... }
  def husbands_hash(user_id)
    hash = {}
    husbands(user_id).each{|m| hash[m.is_profile_id] = m.is_name_id}
    return hash
  end


  def wives(user_id)
    wives = []
    circle(user_id).each do |m|
      wives << m if m.relation_id == 8
    end
    return wives
  end


  #  { profile_id => name_id, profile_id => name_id, ... }
  def wives_hash(user_id)
    hash = {}
    wives(user_id).each{|m| hash[m.is_profile_id] = m.is_name_id}
    return hash
  end


  # Выбор способа UpdatesFeed взавис-ти от текущего кол-ва профилей в дереве
  # Исп-ся в ProfilesController
  def case_update_amounts(profile, current_user)

    # Определение кол-во профилей в дереве после добавления нового профиля
    tree_content_data = Tree.tree_amounts(current_user)
    tree_profiles_amount = tree_content_data[:profiles_qty]
    #logger.info "In create: tree_profiles_amount = #{tree_profiles_amount} "

    case tree_profiles_amount
      when 11 # кол-во родни в дереве больше 10
        ##########  UPDATES FEEDS - № 8  ####################
        UpdatesFeed.create(user_id: current_user.id, update_id: 8, agent_user_id: current_user.id,
                           agent_profile_id: profile.id,  who_made_event: current_user.id, read: false)

      when 16  # кол-во родни в дереве больше 15
        ##########  UPDATES FEEDS - № 9  ####################
        UpdatesFeed.create(user_id: current_user.id, update_id: 9, agent_user_id: current_user.id,
                           agent_profile_id: profile.id, who_made_event: current_user.id, read: false)

      when 21  # кол-во родни в дереве больше 20
        ##########  UPDATES FEEDS - № 10  ####################
        UpdatesFeed.create(user_id: current_user.id, update_id: 10, agent_user_id: current_user.id,
                           agent_profile_id: profile.id, who_made_event: current_user.id, read: false)

      when 26  # кол-во родни в дереве больше 25
        ##########  UPDATES FEEDS - № 11  ####################
        UpdatesFeed.create(user_id: current_user.id, update_id: 11, agent_user_id: current_user.id,
                           agent_profile_id: profile.id, who_made_event: current_user.id, read: false)

      when 31  # кол-во родни в дереве больше 30
        ##########  UPDATES FEEDS - № 12  ####################
        UpdatesFeed.create(user_id: current_user.id, update_id: 12, agent_user_id: current_user.id,
                           agent_profile_id: profile.id, who_made_event: current_user.id, read: false)

      when 41  # кол-во родни в дереве больше 40
        ##########  UPDATES FEEDS - № 13  ####################
        UpdatesFeed.create(user_id: current_user.id, update_id: 13, agent_user_id: current_user.id,
                           agent_profile_id: profile.id, who_made_event: current_user.id, read: false)

      when 51  # кол-во родни в дереве больше 50
        ##########  UPDATES FEEDS - № 14  ####################
        UpdatesFeed.create(user_id: current_user.id, update_id: 14, agent_user_id: current_user.id,
                           agent_profile_id: profile.id, who_made_event: current_user.id, read: false)

      when 101  # кол-во родни в дереве больше 100
        ##########  UPDATES FEEDS - № 15  ####################
        UpdatesFeed.create(user_id: current_user.id, update_id: 15, agent_user_id: current_user.id,
                           agent_profile_id: profile.id, who_made_event: current_user.id, read: false)

      when 151  # кол-во родни в дереве больше 150
        ##########  UPDATES FEEDS - № 16  ####################
        UpdatesFeed.create(user_id: current_user.id, update_id: 16, agent_user_id: current_user.id,
                           agent_profile_id: profile.id, who_made_event: current_user.id, read: false)

      else  # No update

    end

  end


  # @note: Проверка: если оба профиля не удалены,
  #   то они участвуют в отработке логов: redo_deletion_log
  #   for ProfileKeys logs update: one profile could been previously deleted
  def self.check_profiles_exists?(profile_id, is_profile_id)
    logger.info "*** In module Profile.check_profiles_exists: 1ex = #{self.where(id: profile_id, deleted: 0).exists?.inspect} "
    logger.info "*** In module Profile.check_profiles_exists: 2ex = #{self.where(id: is_profile_id, deleted: 0).exists?.inspect} "
    self.where(id: profile_id, deleted: 0).exists? && self.where(id: is_profile_id, deleted: 0).exists?
  end


  # @note: collect Profiles stat
  def self.collect_profile_stats
    all_profiles = where(deleted: 0)
    { profiles: all_profiles.count,
      profiles_male: all_profiles.where(sex_id: 1).count,
      profiles_female: all_profiles.where(sex_id: 0).count
    }
  end



end
