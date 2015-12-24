class WeafamConstants

  # Constants, using in search methods: in start_search and in complete_search
  # def initialize
  # certain_koeff
  CERTAIN_KOEFF =  WeafamSetting.first.certain_koeff

  # exclusion_relations
  EXCLUSION_RELATIONS = WeafamSetting.first.exclusion_relations
  # 23.12.15: [1,2,3,4,5,6,7,8,91,101,111,121,92,102,112,122]

  # certain_connect
  CERTAIN_CONNECT = WeafamSetting.first.certain_connect
  # end


  def show_all_constants
    puts "certain_koeff = #{CERTAIN_KOEFF}, exclusion_relations = #{EXCLUSION_RELATIONS}, certain_connect = #{CERTAIN_CONNECT}"
  end

end
