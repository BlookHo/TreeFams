class Admin::ResetsController < Admin::AdminController


  def new
    # render reset form
  end


  def create
    if params[:password] == '2114'
      reset!
      redirect_to :back, notice: "Данный удалены!"
    else
      redirect_to :back, alert: "Не действительный пароль!"
    end
  end



  private


  def reset!
    User.delete_all
    User.reset_pk_sequence
    User.create([])


    Profile.delete_all
    Profile.reset_pk_sequence
    Profile.create([])


    ProfileData.delete_all
    ProfileData.reset_pk_sequence
    ProfileData.create([])


    Tree.delete_all
    Tree.reset_pk_sequence
    Tree.create([])


    ProfileKey.delete_all
    ProfileKey.reset_pk_sequence
    ProfileKey.create([])


    ConnectionRequest.delete_all
    ConnectionRequest.reset_pk_sequence
    ConnectionRequest.create([])


    ConnectedUser.delete_all
    ConnectedUser.reset_pk_sequence
    ConnectedUser.create([])


    Message.delete_all
    Message.reset_pk_sequence
    Message.create([])


    PendingUser.delete_all
    PendingUser.reset_pk_sequence
    PendingUser.create([])
  end


end
