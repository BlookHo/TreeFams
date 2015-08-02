module Meteor
  module V1
    module Names
      class NamesCreateController < MeteorController

        skip_before_filter :authenticate

        def create
          name = params[:name]
          sex_id = params[:sex_id]
          n = Name.new({name: name, sex_id: sex_id})
          if n.save
            respond_with(status:200)
          else
            respond_with(status:200)
          end
        end

      end
    end
  end
end
