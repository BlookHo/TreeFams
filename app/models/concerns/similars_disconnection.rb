module SimilarsDisconnection
  extend ActiveSupport::Concern
# in User model

# Обратное разъобъединение профилей похожих
#
  def disconnect_sims_in_tables(profiles_to_rewrite, profiles_to_destroy)

    logger.info "*** In module SimilarsDisconnection User disconnect_sims_in_tables:  profiles_to_rewrite = #{profiles_to_rewrite},  profiles_to_destroy = #{profiles_to_destroy} "


  end




end