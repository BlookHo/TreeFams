class WeafamStat < ActiveRecord::Base

  # TO BE TESTED
  validates_presence_of :users, :users_male, :users_female,
                        :profiles, :profiles_male, :profiles_female,
                        :trees, :invitations,
                        :requests, :connections, :refuse_requests,
                        :disconnections, :similars_found,
                        :message => "Должно присутствовать в WeafamStat"
  validates_numericality_of :users, :users_male, :users_female,
                            :profiles, :profiles_male, :profiles_female,
                            :trees, :invitations,
                            :requests, :connections, :refuse_requests,
                            :disconnections, :similars_found,
                            :only_integer => true,
                            :message => "ID автора сообщения или получателя сообщения должны быть целым числом в WeafamStat"
  validates_numericality_of :users, :users_male, :users_female,
                            :profiles, :profiles_male, :profiles_female,
                            :trees, :invitations,
                            :requests, :connections, :refuse_requests,
                            :disconnections, :similars_found,
                            :greater_than_or_equal_to => 0,
                            :message => "ID автора сообщения или получателя сообщения должны быть больше или равно 0 в WeafamStat"






end
