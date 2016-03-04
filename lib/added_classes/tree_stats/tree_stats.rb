class TreeStats

  #############################################################
  # Иванищев А.В. 2016
  # @note: Stat info for one current_user tree
  #############################################################

  # @note: ИСПОЛЬЗУЮТСЯ В METHODS: weafam_mailer.rb

  # @note: collect_tree_stats of tree for current_user_id
  def self.collect_tree_stats(current_user_id)
    puts " In TreeStat: collect_tree_stats: current_user_id = #{current_user_id}"  #unless rows.blank?

    # model         = rename_data[:model]
    # profile_field = rename_data[:profile_field]
    # profile_id    = rename_data[:profile_id]
    # name_field    = rename_data[:name_field]
    # new_name_id   = rename_data[:new_name_id]
    #
    # rows = model.where(profile_field => profile_id)
    # # p " Model TreeAndProfilekey: change_name - rows.size = #{rows.size}" unless rows.blank?
    # rows.each {|one_row| one_row.update_attributes(name_field => new_name_id, updated_at: Time.now)} unless rows.blank?

    {}

  end


end

