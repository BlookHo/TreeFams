class Admin::ResetsController < Admin::AdminController


  def new
    # render reset form
  end


  def create
    if params[:password] == '2114'
      reset!
      redirect_to :back, notice: "Данныe удалены!"
    else
      redirect_to :back, alert: "Не действительный пароль!"
    end
  end


  private

  def reset!

    # User.all.each do |user|
    #   UserMailer.tester_mail(user.email).deliver
    # end

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

    UpdatesFeed.delete_all
    UpdatesFeed.reset_pk_sequence
    UpdatesFeed.create([])

    CommonLog.delete_all
    CommonLog.reset_pk_sequence
    CommonLog.create([])

    ConnectionLog.delete_all
    ConnectionLog.reset_pk_sequence
    ConnectionLog.create([])

    SimilarsFound.delete_all
    SimilarsFound.reset_pk_sequence
    SimilarsFound.create([])

    SimilarsLog.delete_all
    SimilarsLog.reset_pk_sequence
    SimilarsLog.create([])

    SearchResults.delete_all
    SearchResults.reset_pk_sequence
    SearchResults.create([])

    DeletionLog.delete_all
    DeletionLog.reset_pk_sequence
    DeletionLog.create([])


    WeafamStat.delete_all
    WeafamStat.reset_pk_sequence
    WeafamStat.create([
    {users: 0, users_male: 0, users_female: 0, profiles: 0, profiles_male: 0, profiles_female: 0,trees: 0, invitations: 0, requests: 0, connections: 0, refuse_requests: 0, disconnections: 0, similars_found: 0 }
                      ])

    Counter.delete_all
    Counter.reset_pk_sequence
    Counter.create([
    {invites: 0, disconnects: 0}
                   ])



  end


end
