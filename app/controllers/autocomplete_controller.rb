class AutocompleteController < ApplicationController


  def names
    term  = params[:term].mb_chars.downcase.concat("%")
    if params[:sex_id].blank?
      names = Name.where("name like ?", term).select(:name, :sex_id, :id).limit(10)
    else
      names = Name.where("name like ? AND sex_id = ?", term, params[:sex_id]).select(:name, :sex_id, :id).limit(10)
    end
    render json: names
  end

end
