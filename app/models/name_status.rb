class NameStatus

  class << self
    def all
      [
        {id: 0, title: "Ожидает модерации"},
        {id: 1, title: "Утверждено"},
        {id: 2, title: "Иностранное имя"},
        {id: 3, title: "Уменьшительное"},
        {id: 4, title: "Не является именем"},
        {id: 5, title: "Грамматические ошибки"},
      ]
    end

    def show(id)
      self.all.find {|status| status[:id] == id }
    end
  end

end
