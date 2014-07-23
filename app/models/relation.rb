class Relation < ActiveRecord::Base


  def self.position_list
    [1,2,5,6,7,8,3,4]
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
    if base_relation_id == 0 and base_sex_id = 1
      [7]
    # К Автору женщине (нельзя добавить жену)
    elsif base_relation_id == 0 and base_sex_id = 0
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

end
