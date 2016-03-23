class TreeStats

  #############################################################
  # Иванищев А.В. 2016
  # @note: Stat info for one current_user tree
  #############################################################

  # @note: ИСПОЛЬЗУЮТСЯ В METHODS: weafam_mailer.rb

  # @note: collect_tree_stats of tree for current_user_id
  def self.collect_tree_stats(current_user_id)
    puts " In TreeStat: collect_tree_stats: current_user_id = #{current_user_id}"  #unless rows.blank?

    # var tree_uniq = _.uniq( Trees.find({}).fetch(), false, function(d) {return ( d.is_profile_id ) });
    # tree_uniq.forEach( function(treeRow) {
    #                      treeRow.is_sex_id == 1 ? maleProfilesQty++ : femaleProfilesQty++;
    #                    });
    #
    # var connectedUsers = user.connected_users;
    #
    # usersQty:           connectedUsers.length,  // В дереве - юзеров
    # treeProfilesQty:    tree_uniq.length,       // В дереве - профилей
    # maleProfilesQty:    maleProfilesQty,        // В дереве - профилей М
    # femaleProfilesQty:  femaleProfilesQty,      // В дереве - профилей Ж

    current_user = User.find(current_user_id)
    tree_stats = {}
    unless current_user.blank?
      tree_data = Tree.tree_main_data(current_user)

      # tree_data = {   author_tree_arr: author_tree_arr,
      #     tree_profiles: tree_profiles,
      #     qty_of_tree_profiles: qty_of_tree_profiles,
      #     connected_author_arr: connected_author_arr  }

      users_qty = 0
      users_qty = tree_data[:connected_author_arr].length unless tree_data[:connected_author_arr].blank?

      tree_stats[:tree_profiles]        = tree_data[:tree_profiles]
      tree_stats[:connected_users]      = tree_data[:connected_author_arr]
      tree_stats[:qty_of_tree_profiles] = tree_data[:qty_of_tree_profiles]
      tree_stats[:qty_of_tree_users]    = users_qty

      puts " In TreeStats: collect_tree_stats: users_qty = #{users_qty}"

      tree_stats
    end
  end


end

