class ConnectionLog < ActiveRecord::Base


  validates_presence_of :connected_at, :current_user_id, :with_user_id, :table_name, :table_row, :field,
                        :message => "Должно присутствовать в ConnectionLog"

  validates_numericality_of :connected_at, :current_user_id, :with_user_id, :table_row, :only_integer => true,
                            :message => "Должны быть целым числом в ConnectionLog"
  validates_numericality_of :connected_at, :current_user_id, :with_user_id, :table_row, :greater_than => 0,
                            :message => "Должны быть больше 0 в ConnectionLog"

  validates_inclusion_of :field, :in => ["profile_id"], :if => :table_users?
  validates_inclusion_of :field, :in => ["profile_id", "is_profile_id"], :if => :table_trees_pr_keys?
  validates_inclusion_of :field, :in => ["tree_id", "user_id", "deleted"], :if => :table_profiles?
  validates_inclusion_of :table_name, :in => ["trees", "profile_keys", "users", "profiles"]
  # validates_uniqueness_of :table_row, scope: [:table_name, :field]  # при условии, что эти поля одинаковые
      # - тогда поле table_row д.б.uniq

  # validates_presence_of :written, :overwritten, :unless => :writtens_can_be_nil?
  # validates_numericality_of :written, :overwritten, :only_integer => true, :unless => :writtens_can_be_nil?
  # validate :written_fields_are_not_equal, :unless => :writtens_can_be_equal? # :written AND :overwritten

      # custom validations
  # def written_fields_are_not_equal
  #   self.errors.add(:similars_logs,
  #                   'Значения полей в одном ряду не должны быть равны в ConnectionLog.') if self.written == self.overwritten
  # end

  # def writtens_can_be_equal?
  #   self.table_name == "profiles" && self.field == "tree_id"
  # end

  # def writtens_can_be_nil?
  #   # puts "In ConnectionLog Model valid:  table_name = #{self.table_name}, written = #{self.written}, field = #{self.field} "
  #   # puts "In ConnectionLog Model valid:  table_name? = #{self.table_name == "profiles"} "
  #   # puts "In ConnectionLog Model valid:  table_name && field? = #{self.table_name == "profiles" && self.field == "user_id"} "
  #   self.table_name == "profiles" && self.field == "user_id"
  # end

  def table_users?
    self.table_name == "users"
  end

  def table_trees_pr_keys?
    self.table_name == "trees" || self.table_name == "profile_keys"
  end

  def table_profiles?
    self.table_name == "profiles"
  end

  # def field_tree?
  #   self.field == "tree_id"
  # end


  # for RSpec - in User_spec.rb
  scope :at_current_user_connected_fields, -> (current_user_id, connection_id) { where(current_user_id: current_user_id,
                                                                                connected_at: connection_id).
                                                            where(" field = 'profile_id' or field = 'is_profile_id' ")}
  scope :at_current_user_deleted_field, -> (current_user_id, connection_id) { where(current_user_id: current_user_id,
                                                                                       connected_at: connection_id).
                                                            where(" field = 'deleted' ")}


  # Для текущего дерева - получение номера id лога для прогона разъединения trees,
  # ранее объединенных.
  # Если такой лог есть, значит ранее trees они объединялись. Значит теперь их
  # можно разъединять.
  # Последний id (максимальный) из существующих логов - :connected_at
  def self.current_tree_log_id(connected_users)
    # puts "In Model action current_tree_log_id : connected_users = #{connected_users} \n"
    log_connection_id = []
    # Сбор всех id логов, относящихся к текущему дереву
    current_tree_logs_ids = self.where(current_user_id: connected_users).pluck(:connected_at).uniq
    # logger.info "In  1b: @current_tree_logs_ids = #{current_tree_logs_ids} " unless current_tree_logs_ids.blank?
    log_connection_id = current_tree_logs_ids.max unless current_tree_logs_ids.blank?
    # logger.info "In  1b: log_connection_id = #{log_connection_id} " unless log_connection_id.blank?
    log_connection_id
  end


  # From -Module # similars_connect_tree
  # Сохранение массива логов в таблицу ConnectionLog
  def self.store_log(connection_log)
    logger.info "MMMMM *** In model ConnectionLog store_log "
    connection_log.each(&:save)
  end




end


# []58, 57] SR :
# []58, 57] SR 59 : Meteor # uniq_profiles_pairs=> okk
{ 790=>{59=>818, 60=>826},
    792=>{59=>822, 60=>830},
    794=>{59=>820, 60=>825},
    793=>{59=>817, 60=>828},
    806=>{59=>823, 60=>831},
    791=>{59=>821, 60=>829},
    795=>{59=>819, 60=>827},
    807=>{59=>824, 60=>832}}

# [57, 58] results[:uniq_profiles_pairs] =
    {795=>{59=>819, 60=>827},
     790=>{59=>818, 60=>826},
     792=>{59=>822, 60=>830},
     794=>{59=>820, 60=>825},
     793=>{59=>817, 60=>828},
     806=>{59=>823, 60=>831},
     791=>{59=>821, 60=>829},
     807=>{59=>824, 60=>832}}


# [57,58] - diskonnect: Meteor
# [inf] results[:uniq_profiles_pairs]
{790=>{58=>811, 59=>818, 60=>826},
 791=>{59=>821, 60=>829}, 792=>{59=>822, 60=>830},
 794=>{59=>820, 60=>825},
 898=>{58=>896},
 795=>{58=>805, 59=>819, 60=>827}, 793=>{58=>809, 59=>817, 60=>828}}

# [57,58] - before connect [59]: Meteor
# [inf] results[:uniq_profiles_pairs] =
    {795=>{59=>819, 60=>827}, 790=>{59=>818, 60=>826},
     792=>{59=>822, 60=>830},     794=>{59=>820, 60=>825},
     793=>{59=>817, 60=>828}, 806=>{59=>823, 60=>831}, 791=>{59=>821, 60=>829}, 807=>{59=>824, 60=>832}}

# [57,58] + [59]
# Profile merge create ConnectionLogs
#
# [inf] Данные из профиля  793 будут перенесены в профиль 817 (pid:3186)
# [sql] User Load (5.6ms)  SELECT  "users".* FROM "users"  WHERE "users"."profile_id" = $1 LIMIT 1  [["profile_id", 793]] (pid:3186)
# [sql] CACHE (0.0ms)  SELECT  "profiles".* FROM "profiles"  WHERE "profiles"."id" = $1 LIMIT 1  [["id", 819]] (pid:3186)
# [sql] CACHE (0.0ms)  SELECT  "profiles".* FROM "profiles"  WHERE "profiles"."id" = $1 LIMIT 1  [["id", 795]] (pid:3186)
# [inf] IN merge profile: main_profile = #<Profile:0x174a1174>,  opposite_profile = #<Profile:0x17414fbc> (pid:3186)
#                    [inf] Данные из профиля  795 будут перенесены в профиль 819 (pid:3186)
# [sql] User Load (2.4ms)  SELECT  "users".* FROM "users"  WHERE "users"."profile_id" = $1 LIMIT 1  [["profile_id", 795]] (pid:3186)
# [inf] # 1 ##*** In module Profile_Merge log_profiles_connection:


# [#<ConnectionLog id: nil, connected_at: 16, current_user_id: 59, with_user_id: 58, table_name: "users", table_row: 58, field: "profile_id", written: 819, overwritten: 795, created_at: nil, updated_at: nil>] (pid:3186)

# [sql] User Exists (2.9ms)  SELECT  1 AS one FROM "users"  WHERE ("users"."email" = 'anna@aa.aa' AND "users"."id" != 58) LIMIT 1 (pid:3186)
# [sql] SQL (7.0ms)  UPDATE "users" SET "profile_id" = $1, "updated_at" = $2 WHERE "users"."id" = 58  [["profile_id", 819], ["updated_at", "2015-12-28 21:54:42.883189"]] (pid:3186)
# [inf] # 2 ##*** In module Profile_Merge log_profiles_connection:

# [#<ConnectionLog id: nil, connected_at: 16, current_user_id: 59, with_user_id: 58, table_name: "users", table_row: 58, field: "profile_id", written: 819, overwritten: 795, created_at: nil, updated_at: nil>,
# #<ConnectionLog id: nil, connected_at: 16, current_user_id: 59, with_user_id: 58, table_name: "profiles", table_row: 819, field: "user_id", written: 58, overwritten: nil, created_at: nil, updated_at: nil>] (pid:3186)

# [sql] SQL (3.5ms)  UPDATE "profiles" SET "updated_at" = $1, "user_id" = $2 WHERE "profiles"."id" = 819  [["updated_at", "2015-12-28 21:54:42.900164"], ["user_id", 58]] (pid:3186)
# [inf] # 3 ##*** In module Profile_Merge log_profiles_connection:

# [#<ConnectionLog id: nil, connected_at: 16, current_user_id: 59, with_user_id: 58, table_name: "users", table_row: 58, field: "profile_id", written: 819, overwritten: 795, created_at: nil, updated_at: nil>,
# #<ConnectionLog id: nil, connected_at: 16, current_user_id: 59, with_user_id: 58, table_name: "profiles", table_row: 819, field: "user_id", written: 58, overwritten: nil, created_at: nil, updated_at: nil>,
# #<ConnectionLog id: nil, connected_at: 16, current_user_id: 59, with_user_id: 58, table_name: "profiles", table_row: 819, field: "tree_id", written: 58, overwritten: 59, created_at: nil, updated_at: nil>] (pid:3186)

# [sql] SQL (2.0ms)  UPDATE "profiles" SET "tree_id" = $1, "updated_at" = $2 WHERE "profiles"."id" = 819  [["tree_id", 58], ["updated_at", "2015-12-28 21:54:42.961743"]] (pid:3186)
# [inf] *** In  4 module Profile_Merge make_user_profile_link: log_profiles_connection =

# [#<ConnectionLog id: nil, connected_at: 16, current_user_id: 59, with_user_id: 58, table_name: "users", table_row: 58, field: "profile_id", written: 819, overwritten: 795, created_at: nil, updated_at: nil>,
# #<ConnectionLog id: nil, connected_at: 16, current_user_id: 59, with_user_id: 58, table_name: "profiles", table_row: 819, field: "user_id", written: 58, overwritten: nil, created_at: nil, updated_at: nil>,
# #<ConnectionLog id: nil, connected_at: 16, current_user_id: 59, with_user_id: 58, table_name: "profiles", table_row: 819, field: "tree_id", written: 58, overwritten: 59, created_at: nil, updated_at: nil>,
# #<ConnectionLog id: nil, connected_at: 16, current_user_id: 59, with_user_id: 58, table_name: "profiles", table_row: 795, field: "user_id", written: nil, overwritten: 58, created_at: nil, updated_at: nil>] (pid:3186)


#     [sql] SQL (2.2ms)  UPDATE "profiles" SET "user_id" = NULL WHERE "profiles"."id" = 795 (pid:3186)
# [sql] Profile Load (1.6ms)  SELECT  "profiles".* FROM "profiles"  WHERE "profiles"."id" = $1 LIMIT 1  [["id", 818]] (pid:3186)
# [sql] Profile Load (1.7ms)  SELECT  "profiles".* FROM "profiles"  WHERE "profiles"."id" = $1 LIMIT 1  [["id", 790]] (pid:3186)
# [inf] IN merge profile: main_profile = #<Profile:0x143957b0>,  opposite_profile = #<Profile:0x14eb9c54> (pid:3186)
#                    [inf] Данные из профиля  790 будут перенесены в профиль 818 (pid:3186)
# [sql] User Load (8.4ms)  SELECT  "users".* FROM "users"  WHERE "users"."profile_id" = $1 LIMIT 1  [["profile_id", 790]] (pid:3186)
# [inf] # 1 ##*** In module Profile_Merge log_profiles_connection: [#<ConnectionLog id: nil, connected_at: 16, current_user_id: 59, with_user_id: 58, table_name: "users", table_row: 57, field: "profile_id", written: 818, overwritten: 790, created_at: nil, updated_at: nil>] (pid:3186)
# [sql] User Exists (5.0ms)  SELECT  1 AS one FROM "users"  WHERE ("users"."email" = 'aleksei@aa.aa' AND "users"."id" != 57) LIMIT 1 (pid:3186)
# [sql] SQL (1.9ms)  UPDATE "users" SET "profile_id" = $1, "updated_at" = $2 WHERE "users"."id" = 57  [["profile_id", 818], ["updated_at", "2015-12-28 21:54:42.989893"]] (pid:3186)
# [inf] # 2 ##*** In module Profile_Merge log_profiles_connection: [#<ConnectionLog id: nil, connected_at: 16, current_user_id: 59, with_user_id: 58, table_name: "users", table_row: 57, field: "profile_id", written: 818, overwritten: 790, created_at: nil, updated_at: nil>, #<ConnectionLog id: nil, connected_at: 16, current_user_id: 59, with_user_id: 58, table_name: "profiles", table_row: 818, field: "user_id", written: 57, overwritten: nil, created_at: nil, updated_at: nil>] (pid:3186)
# [sql] SQL (2.7ms)  UPDATE "profiles" SET "updated_at" = $1, "user_id" = $2 WHERE "profiles"."id" = 818  [["updated_at", "2015-12-28 21:54:43.002622"], ["user_id", 57]] (pid:3186)
# [inf] # 3 ##*** In module Profile_Merge log_profiles_connection: [#<ConnectionLog id: nil, connected_at: 16, current_user_id: 59, with_user_id: 58, table_name: "users", table_row: 57, field: "profile_id", written: 818, overwritten: 790, created_at: nil, updated_at: nil>, #<ConnectionLog id: nil, connected_at: 16, current_user_id: 59, with_user_id: 58, table_name: "profiles", table_row: 818, field: "user_id", written: 57, overwritten: nil, created_at: nil, updated_at: nil>, #<ConnectionLog id: nil, connected_at: 16, current_user_id: 59, with_user_id: 58, table_name: "profiles", table_row: 818, field: "tree_id", written: 57, overwritten: 59, created_at: nil, updated_at: nil>] (pid:3186)
# [sql] SQL (2.0ms)  UPDATE "profiles" SET "tree_id" = $1, "updated_at" = $2 WHERE "profiles"."id" = 818  [["tree_id", 57], ["updated_at", "2015-12-28 21:54:43.008784"]] (pid:3186)
# [inf] *** In  4 module Profile_Merge make_user_profile_link: log_profiles_connection = [#<ConnectionLog id: nil, connected_at: 16, current_user_id: 59, with_user_id: 58, table_name: "users", table_row: 57, field: "profile_id", written: 818, overwritten: 790, created_at: nil, updated_at: nil>, #<ConnectionLog id: nil, connected_at: 16, current_user_id: 59, with_user_id: 58, table_name: "profiles", table_row: 818, field: "user_id", written: 57, overwritten: nil, created_at: nil, updated_at: nil>, #<ConnectionLog id: nil, connected_at: 16, current_user_id: 59, with_user_id: 58, table_name: "profiles", table_row: 818, field: "tree_id", written: 57, overwritten: 59, created_at: nil, updated_at: nil>, #<ConnectionLog id: nil, connected_at: 16, current_user_id: 59, with_user_id: 58, table_name: "profiles", table_row: 790, field: "user_id", written: nil, overwritten: 57, created_at: nil, updated_at: nil>] (pid:3186)
#     [sql] SQL (2.5ms)  UPDATE "profiles" SET "user_id" = NULL WHERE "profiles"."id" = 790 (pid:3186)
# [sql] Profile Load (1.6ms)  SELECT  "profiles".* FROM "profiles"  WHERE "profiles"."id" = $1 LIMIT 1  [["id", 820]] (pid:3186)
# [sql] Profile Load (1.6ms)  SELECT  "profiles".* FROM "profiles"  WHERE "profiles"."id" = $1 LIMIT 1  [["id", 794]] (pid:3186)
# [inf] IN merge profile: main_profile = #<Profile:0x15526128>,  opposite_profile = #<Profile:0x154fe484> (pid:3186)
#                    [inf] Данные из профиля  794 будут перенесены в профиль 820 (pid:3186)
# [sql] User Load (1.7ms)  SELECT  "users".* FROM "users"  WHERE "users"."profile_id" = $1 LIMIT 1  [["profile_id", 794]] (pid:3186)
# [sql] Profile Load (1.6ms)  SELECT  "profiles".* FROM "profiles"  WHERE "profiles"."id" = $1 LIMIT 1  [["id", 821]] (pid:3186)
# [sql] Profile Load (1.7ms)  SELECT  "profiles".* FROM "profiles"  WHERE "profiles"."id" = $1 LIMIT 1  [["id", 791]] (pid:3186)
# [inf] IN merge profile: main_profile = #<Profile:0x154a1144>,  opposite_profile = #<Profile:0x154487ec> (pid:3186)


#
# [sql] SQL (2.5ms)  INSERT INTO "connection_logs" ("connected_at", "created_at", "current_user_id", "field", "overwritten", "table_name", "table_row", "updated_at", "with_user_id", "written") VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING "id"  [["connected_at", 16], ["created_at", "2015-12-28 21:54:46.067554"], ["current_user_id", 59], ["field", "deleted"], ["overwritten", 0], ["table_name", "profiles"], ["table_row", 807], ["updated_at", "2015-12-28 21:54:46.067554"], ["with_user_id", 58], ["written", 1]] (pid:3186)
# [sql] ConnectionLog Exists (3.0ms)  SELECT  1 AS one FROM "connection_logs"  WHERE ("connection_logs"."table_row" = 792 AND "connection_logs"."table_name" = 'profiles' AND "connection_logs"."field" = 'deleted') LIMIT 1 (pid:3186)
# [sql] SQL (1.9ms)  INSERT INTO "connection_logs" ("connected_at", "created_at", "current_user_id", "field", "overwritten", "table_name", "table_row", "updated_at", "with_user_id", "written") VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING "id"  [["connected_at", 16], ["created_at", "2015-12-28 21:54:46.076825"], ["current_user_id", 59], ["field", "deleted"], ["overwritten", 0], ["table_name", "profiles"], ["table_row", 792], ["updated_at", "2015-12-28 21:54:46.076825"], ["with_user_id", 58], ["written", 1]] (pid:3186)


# ConnectionLog Exists (2.7ms)  SELECT  1 AS one FROM "connection_logs"  WHERE ("connection_logs"."table_row" = 58 AND "connection_logs"."table_name" = 'users' AND "connection_logs"."field" = 'profile_id') LIMIT 1 (pid:3186)

# [sql] ConnectionLog Exists (3.2ms)  SELECT  1 AS one FROM "connection_logs"  WHERE ("connection_logs"."table_row" = 819 AND "connection_logs"."table_name" = 'profiles' AND "connection_logs"."field" = 'user_id') LIMIT 1 (pid:3186)
# [sql] SQL (3.1ms)  INSERT INTO "connection_logs" ("connected_at", "created_at", "current_user_id", "field", "table_name", "table_row", "updated_at", "with_user_id", "written") VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING "id"  [["connected_at", 16], ["created_at", "2015-12-28 21:54:46.093779"], ["current_user_id", 59], ["field", "user_id"], ["table_name", "profiles"], ["table_row", 819], ["updated_at", "2015-12-28 21:54:46.093779"], ["with_user_id", 58], ["written", 58]] (pid:3186)

# [sql] ConnectionLog Exists (5.4ms)  SELECT  1 AS one FROM "connection_logs"  WHERE ("connection_logs"."table_row" = 819 AND "connection_logs"."table_name" = 'profiles' AND "connection_logs"."field" = 'tree_id') LIMIT 1 (pid:3186)
# [sql] SQL (2.0ms)  INSERT INTO "connection_logs" ("connected_at", "created_at", "current_user_id", "field", "overwritten", "table_name", "table_row", "updated_at", "with_user_id", "written") VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING "id"  [["connected_at", 16], ["created_at", "2015-12-28 21:54:46.107330"], ["current_user_id", 59], ["field", "tree_id"], ["overwritten", 59], ["table_name", "profiles"], ["table_row", 819], ["updated_at", "2015-12-28 21:54:46.107330"], ["with_user_id", 58], ["written", 58]] (pid:3186)

# ConnectionLog Exists (2.9ms)  SELECT  1 AS one FROM "connection_logs"  WHERE ("connection_logs"."table_row" = 795 AND "connection_logs"."table_name" = 'profiles' AND "connection_logs"."field" = 'user_id') LIMIT 1 (pid:3186)


# [sql] ConnectionLog Exists (5.2ms)  SELECT  1 AS one FROM "connection_logs"  WHERE ("connection_logs"."table_row" = 57 AND "connection_logs"."table_name" = 'users' AND "connection_logs"."field" = 'profile_id') LIMIT 1 (pid:3186)
# [sql] SQL (3.1ms)  INSERT INTO "connection_logs" ("connected_at", "created_at", "current_user_id", "field", "overwritten", "table_name", "table_row", "updated_at", "with_user_id", "written") VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING "id"  [["connected_at", 16], ["created_at", "2015-12-28 21:54:46.126538"], ["current_user_id", 59], ["field", "profile_id"], ["overwritten", 790], ["table_name", "users"], ["table_row", 57], ["updated_at", "2015-12-28 21:54:46.126538"], ["with_user_id", 58], ["written", 818]] (pid:3186)

# [sql] ConnectionLog Exists (2.8ms)  SELECT  1 AS one FROM "connection_logs"  WHERE ("connection_logs"."table_row" = 818 AND "connection_logs"."table_name" = 'profiles' AND "connection_logs"."field" = 'user_id') LIMIT 1 (pid:3186)
# [sql] SQL (2.0ms)  INSERT INTO "connection_logs" ("connected_at", "created_at", "current_user_id", "field", "table_name", "table_row", "updated_at", "with_user_id", "written") VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING "id"  [["connected_at", 16], ["created_at", "2015-12-28 21:54:46.137246"], ["current_user_id", 59], ["field", "user_id"], ["table_name", "profiles"], ["table_row", 818], ["updated_at", "2015-12-28 21:54:46.137246"], ["with_user_id", 58], ["written", 57]] (pid:3186)

# [sql] ConnectionLog Exists (3.1ms)  SELECT  1 AS one FROM "connection_logs"  WHERE ("connection_logs"."table_row" = 818 AND "connection_logs"."table_name" = 'profiles' AND "connection_logs"."field" = 'tree_id') LIMIT 1 (pid:3186)
# [sql] SQL (1.8ms)  INSERT INTO "connection_logs" ("connected_at", "created_at", "current_user_id", "field", "overwritten", "table_name", "table_row", "updated_at", "with_user_id", "written") VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING "id"  [["connected_at", 16], ["created_at", "2015-12-28 21:54:46.145902"], ["current_user_id", 59], ["field", "tree_id"], ["overwritten", 59], ["table_name", "profiles"], ["table_row", 818], ["updated_at", "2015-12-28 21:54:46.145902"], ["with_user_id", 58], ["written", 57]] (pid:3186)

# [sql] ConnectionLog Exists (2.8ms)  SELECT  1 AS one FROM "connection_logs"  WHERE ("connection_logs"."table_row" = 790 AND "connection_logs"."table_name" = 'profiles' AND "connection_logs"."field" = 'user_id') LIMIT 1 (pid:3186)
# [sql] SQL (3.0ms)  INSERT INTO "connection_logs" ("connected_at", "created_at", "current_user_id", "field", "overwritten", "table_name", "table_row", "updated_at", "with_user_id") VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING "id"  [["connected_at", 16], ["created_at", "2015-12-28 21:54:46.154108"], ["current_user_id", 59], ["field", "user_id"], ["overwritten", 57], ["table_name", "profiles"], ["table_row", 790], ["updated_at", "2015-12-28 21:54:46.154108"], ["with_user_id", 58]] (pid:3186)


# [sql] ConnectionLog Exists (4.3ms)  SELECT  1 AS one FROM "connection_logs"  WHERE ("connection_logs"."table_row" = 765 AND "connection_logs"."table_name" = 'trees' AND "connection_logs"."field" = 'profile_id') LIMIT 1 (pid:3186)
# [sql] SQL (3.1ms)  INSERT INTO "connection_logs" ("connected_at", "created_at", "current_user_id", "field", "overwritten", "table_name", "table_row", "updated_at", "with_user_id", "written") VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING "id"  [["connected_at", 16], ["created_at", "2015-12-28 21:54:46.166953"], ["current_user_id", 59], ["field", "profile_id"], ["overwritten", 793], ["table_name", "trees"], ["table_row", 765], ["updated_at", "2015-12-28 21:54:46.166953"], ["with_user_id", 58], ["written", 817]] (pid:3186)
# [sql] ConnectionLog Exists (2.7ms)  SELECT  1 AS one FROM "connection_logs"  WHERE ("connection_logs"."table_row" = 851 AND "connection_logs"."table_name" = 'trees' AND "connection_logs"."field" = 'profile_id') LIMIT 1 (pid:3186)
# [sql] SQL (2.0ms)  INSERT INTO "connection_logs" ("connected_at", "created_at", "current_user_id", "field", "overwritten", "table_name", "table_row", "updated_at", "with_user_id", "written") VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING "id"  [["connected_at", 16], ["created_at", "2015-12-28 21:54:46.178539"], ["current_user_id", 59], ["field", "profile_id"], ["overwritten", 793], ["table_name", "trees"], ["table_row", 851], ["updated_at", "2015-12-28 21:54:46.178539"], ["with_user_id", 58], ["written", 817]] (pid:3186)
# [sql] ConnectionLog Exists (2.6ms)  SELECT  1 AS one FROM "connection_logs"  WHERE ("connection_logs"."table_row" = 850 AND "connection_logs"."table_name" = 'trees' AND "connection_logs"."field" = 'profile_id') LIMIT 1 (pid:3186)
# [sql] SQL (1.9ms)  INSERT INTO "connection_logs" ("connected_at", "created_at", "current_user_id", "field", "overwritten", "table_name", "table_row", "updated_at", "with_user_id", "written") VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING "id"  [["connected_at", 16], ["created_at", "2015-12-28 21:54:46.187154"], ["current_user_id", 59], ["field", "profile_id"], ["overwritten", 793], ["table_name", "trees"], ["table_row", 850], ["updated_at", "2015-12-28 21:54:46.187154"], ["with_user_id", 58], ["written", 817]] (pid:3186)
# [sql] ConnectionLog Exists (2.9ms)  SELECT  1 AS one FROM "connection_logs"  WHERE ("connection_logs"."table_row" = 849 AND "connection_logs"."table_name" = 'trees' AND "connection_logs"."field" = 'profile_id') LIMIT 1 (pid:3186)
# [sql] ConnectionLog Exists (2.6ms)  SELECT  1 AS one FROM "connection_logs"  WHERE ("connection_logs"."table_row" = 848 AND "connection_logs"."table_name" = 'trees' AND "connection_logs"."field" = 'profile_id') LIMIT 1 (pid:3186)
# [sql] ConnectionLog Exists (2.8ms)  SELECT  1 AS one FROM "connection_logs"  WHERE ("connection_logs"."table_row" = 768 AND "connection_logs"."table_name" = 'trees' AND "connection_logs"."field" = 'profile_id') LIMIT 1 (pid:3186)
