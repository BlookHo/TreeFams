class ProfileKey < ActiveRecord::Base
  include ProfileKeysGeneration
  include SearchHelper

  validates :user_id, :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id,
            :presence => {:message => "Должно присутствовать в ProfileKey"}

  # validates_presence_of :user_id, :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id,
  #                       :message => "Должно присутствовать в ProfileKey"
  validates_numericality_of :user_id, :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id,
                            :greater_than => 0, :message => "Должны быть больше 0 в ProfileKey"
  validates_numericality_of :user_id, :profile_id, :name_id, :relation_id, :is_profile_id, :is_name_id,
                            :only_integer => true,  :message => "Должны быть целым числом в ProfileKey"
  # profile_id and .is_profile_id
  validate :profiles_ids_are_not_equal#, :message => "Значения полей в одном ряду не должны быть равны в ProfileKey"

  validates_inclusion_of :relation_id, :in => [1,2,3,4,5,6,7,8,91,92,101,102,111,112,121,122,13,14,15,16,17,18,191,192,
                                               201,202,211,212,221,222],
                         :message => "Должны быть целым числом из заданного множества в ProfileKey"

  # custom validations
  def profiles_ids_are_not_equal
    if self.profile_id == self.is_profile_id
      self.errors.add(:profile_keys, 'Значения полей в одном ряду не должны быть равны в ProfileKey')
    end
  end

  belongs_to :profile #, dependent: :destroy
  belongs_to :is_profile, foreign_key: :is_profile_id, class_name: Profile
  belongs_to :user
  belongs_to :name, foreign_key: :is_name_id
  # belongs_to :display_name, class_name: Name, foreign_key: :is_display_name_id

  # todo: разобраться здесь с relation_id
  belongs_to :relation, primary_key: :relation_id

  has_many :profile_datas, through: :profile

  # used in Profile
  scope :one_profile_circle,  -> (connected_users_arr, profile) {
                                   where("user_id in (?)", connected_users_arr)
                                  .where(profile_id: profile.id, deleted: 0)
                                  .order('user_id','relation_id','is_name_id' )
                                  .select(:user_id, :profile_id, :name_id, :relation_id, :is_name_id, :is_profile_id)
                                  .distinct
                                  }


  # @note: rename one profile in this model
  def self.rename_in_profile_key(profile_id, new_name_id)
    p "In model ProfileKey profile rename:  profile_id = #{profile_id}, new_name_id = #{new_name_id}"
    rename_data_1 = {
        model:          ProfileKey,
        profile_field:  'profile_id',
        name_field:     'name_id',
        profile_id:     profile_id,
        new_name_id:    new_name_id
    }
    TreeAndProfilekey.change_name(rename_data_1)

    rename_data_2 = {
        model:          ProfileKey,
        profile_field:  'is_profile_id',
        name_field:     'is_name_id',
        profile_id:     profile_id,
        new_name_id:    new_name_id
    }
    TreeAndProfilekey.change_name(rename_data_2)
  end




end
