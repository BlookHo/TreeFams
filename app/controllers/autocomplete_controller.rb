class AutocompleteController < ApplicationController


  def names
    term  = params[:term].mb_chars.capitalize.concat("%")
    if params[:sex_id].blank?
      # names = Name.where("name like ?", term).select(:name, :sex_id, :id, :search_name_id).limit(10)
      @names = Name.approved.where("name like ?", term).limit(10)
    else
      @names = Name.approved.where("name like ? AND sex_id = ?", term, params[:sex_id]).limit(10)
    end
    logger.info "==========="
    logger.info @names.pluck(:name)
    logger.info "==========="
    # render json: json.(names, :name)
  end

end
