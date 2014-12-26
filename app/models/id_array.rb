class IDArray
  # Исп-ся в методе "Тест на выявление Похожих"
  # Перебор по всем возможным различным парам элементов массива

  # consecutive pairs - исходный код
  # define an iterator over each pair of indexes in an array
  #def each_pair_index
  #  (0..(self.length-1)).each do |i|
  #    ((i+1)..(self.length-1 )).each do |j|
  #      yield i, j
  #    end
  #  end
  #end

  # - исходный код
  # define an iterator over each pair of values in an array for easy reuse
  #def each_pair
  #  self.each_pair_index do |i, j|
  #    yield self[i], self[j]
  #  end
  #end

  # consecutive pairs
  # define an iterator over each pair of indexes in an array
  def self.each_pair_index(arr)
    (0..(arr.length-1)).each do |i|
      ((i+1)..(arr.length-1 )).each do |j|
        yield i, j
      end
    end
  end

  # define an iterator over each pair of values in an array for easy reuse
  def self.each_pair(arr)
    each_pair_index(arr) do |i, j|
      yield arr[i], arr[j]
    end
  end





end