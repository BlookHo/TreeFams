class Admin::NamesController < Admin::AdminController

  def index
    @names = Name.parent_names.includes(:synonyms).page params[:page]
  end


  def males
    @names = Name.parent_names.males.page params[:page]
    render template: 'admin/names/index'
  end

  def females
    @names = Name.parent_names.females.page params[:page]
    render template: 'admin/names/index'
  end


  def edit
    @name = Name.find params[:id]
  end

  def new
    @name = Name.new
  end


  def create
    @name = Name.new name_params
    if @name.save
      redirect_to :admin_names, notice: "Имя добавлено"
    else
      render :new
    end
  end


  def update
    @name = Name.find params[:id]
    if @name.update_attributes name_params
      redirect_to :admin_names, notice: "Изменения сохранены"
    else
      render :edit
    end
  end


  def destroy
    if Name.find(params[:id]).destroy
      redirect_to :admin_names, notice: "Имя удалено"
    else
      redirect_to :back, alert: "Ошибка при удалении имени"
    end
  end


  private

  def name_params
    params[:name].permit(:name, :parent_name_id, :sex_id)
  end

end
