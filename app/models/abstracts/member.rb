class Member
  include ActiveModel::Validations
  include ActiveRecord::Callbacks

  attr_accessor :name, :sex_id

  def initialize(name: name, sex_id: sex_id)
    @name = name
    @sex_id = sex_id
  end

  validates :name, :presence => true
  validate  :name_extended
  validates :sex_id, inclusion: [0, 1]


  def name_extended
    current_name = Name.where(name: self.name).first
    # Если имя есть в базе - то просто берем его sex_id
    if current_name
      self.name = current_name.name
      self.sex_id = current_name.sex_id
    # если имени еще нет в базе, но при этом есть его sex_id
    # значит пользователь подтвердил ввод новго имени
    elsif !current_name && ( [0,1].include? self.sex_id )
      new_name = Name.create(name: name, sex_id: sex_id, is_approved: false)
      self.name = new_name.name
      self.sex_id = new_name.sex_id
    # если новое имя - предупреждение и запрос пола
    else
      errors.add(:name_warning, "Вы ввели редоке имя, пожалуйста, подтвердите, выбрав пол")
    end
  end

end


# Author - корень любого дерева
class Author < Member
  attr_accessor :family

  def initialize(family: Family.new, name: "", sex_id: "")
    @name = name
    @sex_id = sex_id
    @family = family
  end

  def add_member(member)
    family.add_member(member)
  end

end



# Author's family
class Family
  attr_accessor :fathers, :mothers
  attr_accessor :brothers, :sisters
  attr_accessor :sons, :daughters
  attr_accessor :husbands, :wives

  def initialize( fathers: [],  mothers: [],
                  brothers: [], sisters: [],
                  sons:[],      daughters: [],
                  husbands: [], wives: [])

    @fathers = fathers
    @mothers = mothers
    @brothers = brothers
    @sisters = sisters
    @sons = sons
    @daughters = daughters
    @husbands = husbands
    @wives = wives
  end

  def add_member(member)
    eval("#{member.class.to_s.pluralize.downcase} << member")
  end

end



# классы расширения
class Father < Member
  validates :name,
            :presence => {:message => "Если вы не знает имени своего отца, используйте свое отчество"}


  def relation_id
    1
  end
end

class Mother < Member
  def relation_id
    2
  end
end

class Son < Member
  def relation_id
    3
  end
end

class Daughter < Member
  def relation_id
    4
  end
end

class Brother < Member
  def relation_id
    5
  end
end

class Sister < Member
  def relation_id
    6
  end
end


class Husband < Member
  def relation_id
    7
  end
end


class Wife < Member
  def relation_id
    8
  end
end
