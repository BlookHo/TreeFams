class ProfileKey < ActiveRecord::Base
  include ProfileKeysGeneration

  belongs_to :profile#, dependent: :destroy
  belongs_to :is_profile, foreign_key: :is_profile_id, class_name: Profile
  belongs_to :user
  belongs_to :name, foreign_key: :is_name_id
  belongs_to :display_name, class_name: Name, foreign_key: :is_display_name_id
  belongs_to :relation, primary_key: :relation_id


  # Это обновления связ. с запросами на объединения
  # Дурацкая запись SQL запроса из-за OR
  def self.search_similars(tree_info)

    if !tree_info.empty?

    tree_info[:current_user]
    tree_info[:tree_profiles_amount]
    tree_info[:connected_users]
    tree_info[:author_tree_arr]
    tree_info[:tree_is_profiles]



      #updates_feeds = UpdatesFeed.where("user_id in (?) or agent_user_id  in (?)", connected_users, connected_users ).where.not(user_id: current_user.id).order('created_at').reverse_order
      logger.info "In select_updates: tree_info = #{tree_info}"
      #UpdatesFeed.create_view_data(read_updates(updates_feeds), current_user.id)
    end
  end





end
