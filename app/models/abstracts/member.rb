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
            :presence => {message: "Нельзя пропутсить ввод имени. Имена радственников в вашем ближенем круге является вашим семейным отпечатком, по которому вы смодете найти свои родственнные свзяи"}
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
    elsif !current_name && !self.sex_id.blank? && ( [0,1].include? self.sex_id.to_i )
      new_name = Name.create(name: self.name, sex_id: self.sex_id.to_i, is_approved: false)
      self.name = new_name.name
      self.sex_id = new_name.sex_id
    # если новое имя - предупреждение и запрос пола
    else
      errors.add(:name_warning, "Вы ввели редкое имя, пожалуйста, подтвердите выбор указав пол")
    end
  end

  # instance method
  def male?
    sex_id == 1
  end

end


# Author - корень любого дерева
class Author < Member
  attr_accessor :family

  def initialize(family: Family.new, name: "", sex_id: "", relation_id: relation_id)
    @name = name
    @sex_id = sex_id
    @relation_id = self.relation_id
    @family = family
  end

  def add_member(member)
    family.add_member(member)
  end

  def relation_id
    0
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

  # Перезаписываем членов, чтобы избежать дублирования при ошибках валидации,
  # поскольку нам приходиться сохранять даже не валидные данные
  def add_member(member)
    eval("self.#{member.class.to_s.pluralize.downcase}=[]")
    eval("#{member.class.to_s.pluralize.downcase}") << member
  end

  # если есть, мы просто не даем создавать новых "пустых" членов семьи
  # def unnamed_memebrs(members)
  #   eval("#{members}").collect{ |m| m.name.blank? }
  # end
  #
  # def cleanup_unnamed_memebrs
  #   %w[fathers mothers brothers sisters sons daughters husbands wives].each do |members|
  #     if eval("#{members}").size >= 2 and unnamed_memebrs(members).size >= 1
  #       eval("#{members}").delete_if { |m| m.name.blank? }
  #     end
  #   end
  # end

end



# классы расширения
class Father < Member
  validates :name,
            :presence => {:message => "Если вы не знаете имени своего отца, используйте свое отчество в качестве производного. Например: Сергеевич - Сергей"}


  def relation_id
    1
  end
end



class Mother < Member
  validates :name,
            :presence => {:message => "На данном шаге нельзя пропустить имя матери, но если вы его не знаете, выберите из списка пункт 'Не известно'"}

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
