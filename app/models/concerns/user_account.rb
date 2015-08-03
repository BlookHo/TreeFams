module UserAccount
  extend ActiveSupport::Concern

  module ClassMethods

    def create_user_account_with_json_data(data, password)

      # Create author
      user = User.create_with_email_and_password( data["author"]["email"], password )
      user.profile = create_profile( data["author"].merge({tree_id: user.id}.as_json) )

      # Create base relation
      data.except('author', 'father_father', 'father_mother', 'mother_father', 'mother_mother').each do |key, value|
        if value.kind_of? Array # brothres, sisters
          value.each do |v|
            create_keys(key, v, user)
          end
        else
          create_keys( key, value, user )
        end
      end

      # Create extra relation for father(father-father, etc) and mother(mother-mother, mother-father)
      data.except('author', 'father', 'mother', 'brothers', 'sisters', 'sons', 'daughters', 'wife', 'husband').each do |key, value|
        logger.info "================ TEST EXTRA KEY"
        logger.info "==KEY: #{key}"
        logger.info "==VALUE: #{value}"
        logger.info "================ END TEST EXTRA KEY"
        create_extra_keys( key, value, user )
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
        ProfileKey.add_new_profile(
          user.profile.sex_id,
          user.profile,
          create_profile(data.merge({tree_id: user.id}.as_json)),
          Relation.name_to_id(relation_name),
          exclusions_hash: nil,
          tree_ids: user.get_connected_users
        )
    end




    def create_extra_keys(relation_name, data, user)

      extra_profile = get_extra_profile(relation_name, user)

      ProfileKey.add_new_profile(
        extra_profile.sex_id,
        extra_profile,
        create_profile(data.merge({tree_id: user.id}.as_json)),
        get_id_for_extra_relation(relation_name),
        exclusions_hash: nil,
        tree_ids: user.get_connected_users
      )
    end




    def get_extra_profile(relation_name, user)
      logger.info("=================")
      logger.info(relation_name)
      logger.info(user)
      logger.info("=================")
      if relation_name == 'father_father' || relation_name == 'father_mother'
        return user.profile.fathers(user.id).first.is_profile
      else
        return user.profile.mothers(user.id).first.is_profile
      end
    end



    def get_id_for_extra_relation(relation_name)
      if relation_name == 'father_father' || relation_name == 'mother_father'
        return 1
      else
        return 2
      end
    end


  end
end
