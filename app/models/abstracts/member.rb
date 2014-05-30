class Member
  include ActiveModel::Validations
  include ActiveRecord::Callbacks

  attr_accessor :name, :sex_id

  def initialize(name: name, sex_id: sex_id, relation_id: relation_id)
    @name = name
    @sex_id = sex_id
    @relation_id = self.relation_id
  end

  validates :name,
            :presence => {message: "Нельзя пропустить ввод имени. Имена радственников в вашем ближнем круге являются вашим семейным отпечатком, по которому будут строиться родственнные связи"}
  validate  :name_extended
  validates :sex_id, inclusion: [0, 1]


  def name_extended
    # имя приводим к нижнему регистру
    current_name = Name.where(name: self.name.mb_chars.downcase).first
    # Если имя есть в базе - то просто берем его sex_id
    if current_name
      self.name = current_name.name
      self.sex_id = current_name.sex_id
    # если имени еще нет в базе, но при этом есть его sex_id
    # значит пользователь подтвердил ввод новго имени
    elsif !current_name && !self.sex_id.blank? && ( [0,1].include? self.sex_id.to_i )
      new_name = Name.create(name: self.name.mb_chars.downcase, sex_id: self.sex_id.to_i, is_approved: false)
      self.name = new_name.name
      self.sex_id = new_name.sex_id
    # если новое имя - предупреждение и запрос пола
    else
      errors.add(:name_warning, "Вы ввели редкое имя, пожалуйста, подтвердите выбор указав пол")
    end
  end

end


# Author - корень любого дерева
class Author < Member
  attr_accessor :family, :email

  def initialize(family: Family.new, name: "", sex_id: "", relation_id: relation_id, email:email)
    @name = name
    @sex_id = sex_id
    @relation_id = self.relation_id
    @email = email
    @family = family
  end

  # Proxy methods
  def add_member(member)
    family.add_member(member)
  end

  def add_members(members)
    family.add_members(members)
  end

  def relation_id
    0
  end

  # Instance method
  def male?
    sex_id == 1
  end

  # Class methods
  # Может ли быть несколько инстансов у одного автора?
  def self.allow_multiple?
    false
  end

  # Convert to array
  def to_array
    result = []
    result << [self.relation_id, self.name, self.sex_id]
    family.members.each do |members|
      members.each do |member|
        result << [member.relation_id, member.name, member.sex_id]
      end
    end
    result
  end

end



# Author's family
class Family
  attr_accessor :fathers, :mothers
  attr_accessor :brothers, :sisters
  attr_accessor :sons, :daughters
  attr_accessor :husbands, :wives
  attr_reader :members

  def initialize( fathers: [],  mothers: [],
                  brothers: [], sisters: [],
                  sons:[],      daughters: [],
                  husbands: [], wives: [])

    @fathers = fathers
    @mothers = mothers
    @brothers = brothers
    @sisters = sisters
    @husbands = husbands
    @wives = wives
    @sons = sons
    @daughters = daughters
  end

  # Перезаписываем членов, чтобы избежать дублирования при ошибках валидации,
  # поскольку нам приходиться сохранять даже не валидные данные
  def clear_member(member)
    eval("self.#{member.class.to_s.pluralize.downcase}=[]")
  end

  def add_members(members)
    if members.kind_of?(Array)
      clear_member(members.first)
      members.each {|member| add_member(member) }
    else
      clear_member(members)
      add_member(members)
    end
  end

  def add_member(member)
    eval("#{member.class.to_s.pluralize.downcase}") << member
  end

  def members
    [fathers, mothers, brothers, sisters,  husbands, wives, sons, daughters]
  end

end



# классы расширения
class Father < Member
  validates :name,
            :presence => {:message => "Если вы не знаете имени своего отца, используйте свое отчество в качестве производного. Например: Сергеевич - Сергей"}

  def relation_id
    1
  end

  # Class methods
  def self.sex_id
    1
  end

  # Class methods
  # Может ли быть несколько инстансов у одного автора?
  def self.allow_multiple?
    false
  end


  def self.descriptions
    %w[отец отца́ отцу́ отца́ отцо́м отца́]
  end
end



class Mother < Member
  validates :name,
            :presence => {:message => "На данном шаге нельзя пропустить имя матери, но если вы его не знаете, выберите из списка пункт 'Не известно'"}

  def relation_id
    2
  end

  # Class methods
  def self.sex_id
    0
  end

  def self.allow_multiple?
    false
  end

  def self.descriptions
    %w[мать ма́тери ма́тери ма́ть ма́терью ма́тери]
  end
end


class Son < Member
  def relation_id
    3
  end
  # Class methods
  def self.sex_id
    1
  end

  def self.allow_multiple?
    true
  end

  def self.descriptions
    %w[сын сына сына сын сыном сына]
  end
end


class Daughter < Member
  def relation_id
    4
  end
  # Class methods
  def self.sex_id
    0
  end

  def self.allow_multiple?
    true
  end

  def self.descriptions
    %w[дочь дочери дочери дочь дочью дочери]
  end
end


class Brother < Member
  def relation_id
    5
  end
  # Class methods
  def self.sex_id
    1
  end

  def self.allow_multiple?
    true
  end

  def self.descriptions
    %w[брат брата́ брату́ брата́ брато́м брата́]
  end
end


class Sister < Member
  def relation_id
    6
  end
  # Class methods
  def self.sex_id
    0
  end

  def self.allow_multiple?
    true
  end

  def self.descriptions
    %w[сестра сестру́ сестру́ сестра́ сестрой сестру́]
  end
end


class Husband < Member
  def relation_id
    7
  end
  # Class methods
  def self.sex_id
    1
  end

  def self.allow_multiple?
    false
  end

  def self.descriptions
    %w[муж мужа мужу мужа мужем мужа]
  end
end


class Wife < Member
  def relation_id
    8
  end
  # Class methods
  def self.sex_id
    0
  end

  def self.allow_multiple?
    false
  end

  def self.descriptions
    %w[жена жену жену жену женой жены]
  end
end
