class Relation < ActiveRecord::Base


  def self.position_list
    [1,2,5,6,7,8,3,4]
  end


  def self.name_to_id(name)
    case name
      when 'author'         then 0
      when 'father'         then 1
      when 'mother'         then 2
      when 'sons'           then 3
      when 'daughters'      then 4
      when 'brothers'       then 5
      when 'sisters'        then 6
      when 'husband'        then 7
      when 'wife'           then 8
      when 'father_father'  then 91
      when 'father_mother'  then 101
      when 'mother_father'  then 92
      when 'mother_mother'  then 102
    end
  end



  def self.to_hash
    {
      fathers:   {title: "Отец",   id: 1},
      mothers:   {title: "Мать",   id: 2},
      sons:      {title: "Сын",    id: 3},
      daughters: {title: "Дочь",   id: 4},
      brothers:  {title: "Брат",   id: 5},
      sisters:   {title: "Сестра", id: 6},
      husbands:  {title: "Муж",    id: 7},
      wives:     {title: "Жена",   id: 8}
    }
  end


  def self.all_to_hash
    {
      author:    {title: "Автор",  id: 0},
      fathers:   {title: "Отец",   id: 1},
      mothers:   {title: "Мать",   id: 2},
      sons:      {title: "Сын",    id: 3},
      daughters: {title: "Дочь",   id: 4},
      brothers:  {title: "Брат",   id: 5},
      sisters:   {title: "Сестра", id: 6},
      husbands:  {title: "Муж",    id: 7},
      wives:     {title: "Жена",   id: 8}
    }
  end


  def self.relation_for_auhtor
    [
      {title: "Отец",   id: 1},
      {title: "Мать",   id: 2},
      {title: "Сын",    id: 3},
      {title: "Дочь",   id: 4},
      {title: "Брат",   id: 5},
      {title: "Сестра", id: 6},
      {title: "Муж",    id: 7},
      {title: "Жена",   id: 8}
    ]
  end



  # Невозможные отношения к добавляемуму профилю
  def self.invalid_relation_ids_to(base_relation_id: base_relation_id, base_sex_id: base_sex_id)
    base_relation_id = base_relation_id.to_i
    base_sex_id = base_sex_id.to_i
    # К Автору мужчине (нельзя добавить мужа)
    if base_relation_id == 0 and base_sex_id == 1
      [7]
    # К Автору женщине (нельзя добавить жену)
    elsif base_relation_id == 0 and base_sex_id == 0
      [8]
    # К Отцу (нельзя добавить мужа)
    elsif base_relation_id == 1
      [7]
    # К Матери (нельзя добавить жену)
    elsif base_relation_id == 2
      [8]
    # К Сыну (нельзя добавить мужа)
    elsif base_relation_id == 3
      [7]
    # К Дочери (нельзя добавить жену)
    elsif base_relation_id == 4
      [8]
    # К Брату (нельзя добавить мужа)
    elsif base_relation_id == 5
      [7]
    # К Сестре (нельзя добавить жену)
    elsif base_relation_id == 6
      [8]
    # К Мужу (нельзя добавить мужа)
    elsif base_relation_id == 7
      [7]
    # К Жене (нельзя добавить жену)
    elsif base_relation_id == 8
      [8]
    else
      []
    end
  end



  def self.relations_for_sex(sex_id)
    case sex_id
      when 1
        [
          {title: "Отец",   id: 1},
          {title: "Мать",   id: 2},
          {title: "Сын",    id: 3},
          {title: "Дочь",   id: 4},
          {title: "Брат",   id: 5},
          {title: "Сестра", id: 6},
          # {title: "Муж",    id: 7},
          {title: "Жена",   id: 8}
        ]
      when 0
        [
          {title: "Отец",   id: 1},
          {title: "Мать",   id: 2},
          {title: "Сын",    id: 3},
          {title: "Дочь",   id: 4},
          {title: "Брат",   id: 5},
          {title: "Сестра", id: 6},
          {title: "Муж",    id: 7},
          # {title: "Жена",   id: 8}
        ]
      else
        []
      end
  end



  def self.name_by_id(relation_id)
    case relation_id
      when 1 then 'отец'
      when 2 then 'мать'
      when 3 then 'сын'
      when 4 then 'дочь'
      when 5 then 'брат'
      when 6 then 'сестра'
      when 7 then 'муж'
      when 8 then 'жена'
    end
  end


  # Возвращает обратное отношение по прямому отношению + имя, из котрого берется пол
  # Примерно: он отец для Алексей => вернет сын
  # Примерно: он отец для Аллы => вернет дочь
  def self.reverse_by_name_id(name_id: name_id, relation_id: relation_id)
    name = Name.find(name_id)
    # к мужским именам
    # он отец для Серегея
    if name.sex_id == 1
      case relation_id
        when 1 then 3
        when 2 then 3
        when 3 then 1
        when 4 then 1
        when 5 then 5
        when 6 then 5
        when 7 then 7
        when 8 then 7
      end
    # к женским именам
    # он отец для Натальи
    else
      case relation_id
        when 1 then 4
        when 2 then 4
        when 3 then 2
        when 4 then 2
        when 5 then 6
        when 6 then 6
        when 7 then 8
        when 8 then 8
      end
    end
  end


  # Возвращает sex_id добавляемого отношения
  def self.sex_id_for_relation_id(relation_id)
      if [1,3,5,7].include? relation_id.to_i
        return 1
      else
        return 0
      end
  end


end
