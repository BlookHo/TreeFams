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

end
