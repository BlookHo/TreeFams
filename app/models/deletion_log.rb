class DeletionLog < ActiveRecord::Base





  # From -Module ProfileDestroying
  # Сохранение массива логов в таблицу DeletionLog
  def self.store_deletion_log(deletion_log)
    puts "In model DeletionLog store_log: deletion_log.size = #{deletion_log.size} " unless deletion_log.blank?
    deletion_log.each(&:save)
  end






end
