class Relation < ActiveRecord::Base


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

end
