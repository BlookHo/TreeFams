class NamesController < ApplicationController

   layout 'application.new'
   before_filter :logged_in?, except: :find


    def find
      term  = params[:term].mb_chars.capitalize
      @name = Name.where(name: term).first
      render nothing: true, status: :not_found unless @name
    end


    def new
      @name = Name.new
      @name.name =  params[:name].mb_chars.capitalize if params[:name]
      @name.sex_id =  params[:sex_id] if params[:sex_id]
      @parent_names = Name.parent_names
    end


    def create
      @name = Name.new name_params
      if @name.save
        redirect_to home_path, notice: "Имя добавлено. Мы вам сообщим, когда имя будет утверждено модератором."
      else
        @parent_names = Name.parent_names
        render :new
      end
    end


    private

    def name_params
      params[:name].permit(:name, :parent_name_id, :sex_id)
    end

end
