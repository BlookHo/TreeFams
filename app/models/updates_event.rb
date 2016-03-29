class UpdatesEvent < ActiveRecord::Base

  validates_presence_of :name, :message => "Должно присутствовать в UpdatesEvent"



# registration                      User
# login                  User
# logout                  User
# profile create                  Profile
# profile rename                  Profile
# profile delete                  Profile
# profile_data last_name                  ProfileData
# profile_data biography                  ProfileData
# profile_data birthday                  ProfileData
# profile_data country                  ProfileData
# profile_data city                  ProfileData
# profile_data avatar_mongo_id                  ProfileData
# profile_data photos                  ProfileData
# profile_data deathdate                  ProfileData
# profile_data prev_last_name                  ProfileData
# profile_data birth_place                  ProfileData
# conn_request                  ConnectionRequest
# connection                  ConnectedUser
# similars_found                  SimilarsFound
# similars connection                  SimilarsLog
# message sent                  messages
# invite email sent                  user
# users post                  user
# search result                  SearchResults
# profiles amount multiples 10                  Profile
# rollback                  CommonLog
#
#
# .


end
