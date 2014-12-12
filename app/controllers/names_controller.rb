class NamesController < ApplicationController

    def find
      term  = params[:term].mb_chars.capitalize
      @name = Name.where(name: term).first
    end

end
