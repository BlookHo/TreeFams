module Meteor
  module V1
    module Profiles
      class ProfilesController < MeteorController
          def destroy
            data = {data: "test data"}
            respond_with data
          end
      end
    end
  end
end
