class NamesController < ApplicationController

    def find
      term  = params[:term].mb_chars.capitalize
      @name = Name.where(name: term).first
      render nothing: true, status: :not_found unless @name
    end

end
