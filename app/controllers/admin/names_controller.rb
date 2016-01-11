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


  def pending
    @names = Name.pending.page params[:page]
    render template: 'admin/names/index'
  end

  def duplicates
    @names = Name.select("COUNT(name) as total, name").
               group(:name).
               having("COUNT(name) > 1").
               order(:name).
               map{|p| {p.name => p.total} }
    render template: 'admin/names/index'
  end



  def edit
    @name = Name.find params[:id]
    @parent_names = Name.parent_names
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
      path = @name.sex_id == 1 ? :males_admin_names : :females_admin_names
      redirect_to path, notice: "Имя добавлено"
    else
      @parent_names = Name.parent_names
      render :new
    end
  end


  def update
    @name = Name.find params[:id]
    if @name.update_attributes name_params
      path = @name.sex_id == 1 ? :males_admin_names : :females_admin_names
      redirect_to path, notice: "Изменения сохранены"
    else
      @parent_names = Name.parent_names
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
    params[:name].permit(:name, :parent_name_id, :sex_id, :is_approved)
  end

end
