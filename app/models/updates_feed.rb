class UpdatesFeed < ActiveRecord::Base

  validates_presence_of :user_id, :update_id, :message => "Должно присутствовать в UpdatesFeed"
  validates_numericality_of :user_id, :update_id, :only_integer => true, :message => "ID автора нового события и ID события должны быть целым числом в UpdatesFeed"
  validates_numericality_of :user_id, :update_id, :greater_than => 0, :message => "ID автора нового события и ID события должны быть больше 0 в UpdatesFeed"
  validates_inclusion_of :read, :in => [true, false]


  def self.select_updates(current_user)
    updates_feeds = UpdatesFeed.where(user_id: current_user.get_connected_users, read: false)
    logger.info "In select_updates: updates_feeds.size = #{updates_feeds.size}"
    UpdatesFeed.read_updates(updates_feeds)
    #UpdatesFeed.last.lol
    updates_feeds
  end

  def self.read_updates(updates_feeds)
    updates_feeds.each do |one_update|
      #one_update.read = true
      one_update.save
      #logger.info "In read_updates: save: one_update.read = #{one_update.read} "
    end
  end

    #def lol
    #  "5"
    #end

  # Извлечение данных одного обновления для View
  def data_update(updates_feed_id)
    one_update = UpdatesEvent.find(updates_feed_id)
    { text: one_update.name, image: one_update.image }
  end


end
