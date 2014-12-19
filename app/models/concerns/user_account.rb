module UserAccount
  extend ActiveSupport::Concern

  module ClassMethods

    def create_user_account_with_json_data(data)
      user = User.create_with_email( data["author"]["email"] )
      user.profile = create_profile( data["author"].merge({tree_id: user.id}.as_json) )
      data.except('author').each do |key, value|
        if value.kind_of? Array # brothres, sisters
          value.each do |v|
            create_keys(key, v, user)
          end
        else
          create_keys( key, value, user )
        end
      end
      return user
    end


    def create_profile(data)
      Profile.create({
        name_id:          data['search_name_id'],
        display_name_id:  data['id'],
        sex_id:           data['sex_id'],
        tree_id:          data['tree_id']
        })
    end




    def create_keys(relation_name, data, user)
        ProfileKey.add_new_profile(user.profile.sex_id,
        user.profile,
        create_profile(data.merge({tree_id: user.id}.as_json)),
        Relation.name_to_id(relation_name),
        exclusions_hash: nil,
        tree_ids: user.get_connected_users
        )
    end


  end
end
