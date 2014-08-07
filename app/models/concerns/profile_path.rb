module ProfilePath
  extend ActiveSupport::Concern

  ############# МЕТОДЫ ФОРМИРОВАНИЯ ХЭША ПУТЕЙ ДЛЯ РЕЗ-ТОВ ПОИСКА

  # Делаем пути по результатам поиска - для отображения
  # @note GET /
   def make_search_results_paths(final_reduced_profiles_hash) #,final_reduced_relations_hash)
     @search_path_hash = Hash.new
     @new_search_path_hash = Hash.new  # NEW_PATH_W_START_PROFILE
     final_reduced_profiles_hash.each do |k_tree,v_tree|
       paths_arr = []
       new_paths_arr = []
       one_path_hash = Hash.new

       one_wide_hash = Hash.new  # NEW_PATH_W_START_PROFILE
       val_arr = []  # NEW_PATH_W_START_PROFILE

       #start_profile = User.find(k_tree).profile_id
       one_tree_hash = get_tree_hash(k_tree)
       @one_tree_hash = one_tree_hash # DEBUGG_TO_VIEW
       v_tree.each do |each_k,v_tree_hash|
         results_qty = v_tree_hash.size
         @v_tree_hash = v_tree_hash # DEBUGG_TO_VIEW
         v_tree_hash.each do |finish_profile|
           one_path_hash = make_path(one_tree_hash, finish_profile, results_qty)
           @one_path_hash = one_path_hash # DEBUGG_TO_VIEW
           paths_arr << one_path_hash

           val_arr = one_wide_hash.values_at(each_k).flatten.compact  # NEW_PATH_W_START_PROFILE
           #logger.info "DEBUG IN make_search_results_paths: before << #{@val_arr.inspect}"
           val_arr << one_path_hash   # NEW_PATH_W_START_PROFILE
           #logger.info "DEBUG IN make_search_results_paths: after << #{@val_arr.inspect}"
           one_wide_hash.merge!({each_k => val_arr})  # NEW_PATH_W_START_PROFILE
           @one_wide_hash = one_wide_hash # DEBUGG_TO_VIEW
           #new_paths_arr << one_wide_hash

         end
         #new_paths_arr << one_wide_hash
       end


       # Основной результат = @search_path_hash
       @search_path_hash.merge!({k_tree => paths_arr}) # наполнение хэша хэшами
       # Основной результат = @new_search_path_hash
       @new_search_path_hash.merge!({k_tree => one_wide_hash}) # # NEW_PATH_W_START_PROFILE  наполнение хэша хэшами  # NEW_PATH_W_START_PROFILE
     end
   end

   # Добавляем один хэш в один path рез-тов поиска
   #
   def add_one_hash_to_one_path(tree_hash, finish_profile, results_qty, end_profile)
     qty = 0
     start_elem_arr = tree_hash.values_at(end_profile)[0] #
     relation_to_next_profile = start_elem_arr[0]
     elem_next_profile = start_elem_arr[1]
     qty = results_qty if end_profile == finish_profile
     @one_path_hash.merge!(make_one_hash_in_path(end_profile, relation_to_next_profile, qty))
     return @one_path_hash, relation_to_next_profile, elem_next_profile
   end

   # Делаем один path рез-тов поиска - далее он включается в итоговый хэш
   #
   def make_path(tree_hash, finish_profile, results_qty)
     @one_path_hash = Hash.new
     end_profile = finish_profile
     @one_path_hash, relation_to_next_profile, elem_next_profile = add_one_hash_to_one_path(tree_hash, finish_profile, results_qty, end_profile)
     while relation_to_next_profile != 0 do
       @one_path_hash, new_elem_relation, new_next_profile = add_one_hash_to_one_path(tree_hash, finish_profile, results_qty, elem_next_profile)
       elem_next_profile = new_next_profile
       relation_to_next_profile = new_elem_relation
     end
     return Hash[@one_path_hash.to_a.reverse] #.reverse_order - чтобы шли от автора
   end

   # Получаем дерево в виде хэша для данного tree_user_id
   #
   def get_tree_hash(tree_user_id)
     return {} if tree_user_id.blank?
     tree_hash = Hash.new
     user_tree = Tree.where(:user_id => tree_user_id)  #
     if !user_tree.blank?
       user_tree.each do |tree_row|
         tree_hash.merge!({tree_row.is_profile_id => [tree_row.relation_id, tree_row.profile_id]})
       end
       return tree_hash
     end
   end

   # Делаем один хэш в один path рез-тов поиска
   #
   def make_one_hash_in_path(one_profile, one_relation, results_qty)
     one_hash_in_path = Hash.new
     one_hash_in_path.merge!({one_profile => {one_relation => results_qty}})
     return one_hash_in_path
   end

   #### КОНЕЦ МЕТОДОВ ФОРМИРОВАНИЯ ХЭША ПУТЕЙ ДЛЯ РЕЗ-ТОВ ПОИСКА

end
