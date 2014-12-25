# encoding: utf-8

class MessagesController < ApplicationController
  include MessagesHelper

  layout 'application.new'


  before_filter :logged_in?


  # if current_user # && !banned?

  # GET /messages
  # GET /messages.json
  # Показываем все диалоги текущего юзера
  # с возможностью перехода к просмотру одного выбранного диалога
  # с одним юзером.
  def index
    @new_messages_count = count_new_messages  # To show in View
    agents_talks = Message.find_agents(current_user) # find all contragent of current_user by messages
    @talks_and_messages = Message.view_messages_data(agents_talks, current_user)  # To show in View
    @one_dialoge_length = 1
    @current_user = current_user
  end


  # Получаем диалог одного юзера
  def show_one_dialoge

      @new_messages_count = count_new_messages

      user_id = params[:user_talk_id] # From view
      user_dialoge = Message.get_user_messages(user_id, current_user)
      @talks_and_messages = []
      @talks_and_messages << user_dialoge
      @one_dialoge_length = user_dialoge[user_id].length if !user_dialoge[user_id].blank?
      @display_receiver_name4 = User.show_user_name(user_id, 4)
      @display_receiver_name2 = User.show_user_name(user_id, 2)

  end

  # Удаление одного диалога - всех взаимных сообщений с Юзером = user_talk_id
  # @param data [params[:user_talk_id]] юзер с которым диалог - акщь мшуц
  def delete_one_dialogue
    user_dialogue = params[:user_talk_id]
   # @user_dialogue = user_dialogue
    unless user_dialogue.blank?
      @user_dialogue_name = User.show_user_name(user_dialogue, 4)
      #logger.info "In delete_one_dialoge: user_dialogue_name = #{@user_dialogue_name}"
      flash[:notice] = "Происходит удаление твоего диалога с #{@user_dialogue_name} "
      Message.delete_one_dialogue(user_dialogue, current_user)
      @deleted =
      @text_to_js = " Удален! "
      flash[:notice] = "Удаление твоего диалога с #{@user_dialogue_name} - завершено"
    end
  end


  # Пометка в БД выбранного сообщения как Удаленного
  # @param data [params[:message_id]] ID выбранного для удаления сообщения - из view
  #
  def delete_message

    unless params[:message_id].blank?
      one_message = Message.find(params[:message_id])
      one_message.delete_one_message(one_message, current_user)
      @receiver_del = one_message.receiver_deleted  # to js
      @sender_del = one_message.sender_deleted  # to js
      check_deletion(one_message)
      #flash[:notice] = "Сообщение удалено"
    end

  end

  # Сигнал-я о корректности "удаления"
  def check_deletion(one_message)
    if one_message.persisted?
      flash[:success] = "Сообщение удалено"
    else
      flash[:error] = "Ошибки при удалении сообщения"
    end
  end


  # Пометка сообщения как Важного (important_message) и обратно - в Неважное
  # @param data [params[:message_id]] ID помеченного как важного сообщения - из view
  def mark_important
    unless params[:message_id].blank?
      Message.important_message(params[:message_id], current_user ) #
      flash[:notice] = "Изменена пометка важности сообщения"
      @mark_important = Message.find(params[:message_id]).important  # to js
      # todo: отображение изменения значения (js)
    end

    respond_to do |format|
      format.html
      format.js { render 'messages/mark_important' }
    end


  end


  # later - Пометка сообщения как Spam
  def spam_dialoge
    user_id = params[:user_id] # From view
    #
  end

  # Создание и сохранение нового сообщения
  def send_message

    @receiver_id = params[:receiver_id]#.to_i # From view
    @receiver_id.present? ? @display_receiver_name = User.show_user_name(@receiver_id, 2) : @receiver_name = ''
    @text = params[:text] # From view
    Message.create(text: @text, receiver_id: @receiver_id, sender_id: current_user.id) if !(@receiver_id.blank? || @text.blank?)

  end




end

#== END OF start_search =========================
#        ======== search_data:
   {:connected_author_arr=>[3],
    :qty_of_tree_profiles=>5,
    :profiles_relations_arr=>
        [{20=>{62=>3, 19=>8, 17=>15, 18=>16}},
         {19=>{17=>1, 18=>2, 62=>3, 16=>6, 20=>7}},
         {62=>{20=>1, 19=>2, 17=>92, 18=>102, 16=>202}},
         {17=>{19=>4, 16=>4, 18=>8, 20=>18, 62=>112}},
         {18=>{19=>4, 16=>4, 17=>7, 20=>18, 62=>112}}],
    :profiles_found_arr=>
        [{20=>{1=>{13=>[3, 8, 15, 16]},
               2=>{13=>[3, 8, 15, 16]}}},
         {19=>{1=>{7=>[1, 2, 3, 7]},
               2=>{7=>[1, 2, 3, 6, 7]}}},
         {62=>{1=>{11=>[1, 2, 92, 102]},
               2=>{11=>[1, 2, 92, 102, 202]}}},
         {17=>{1=>{8=>[4, 8, 18, 112]},
               2=>{8=>[4, 4, 8, 18, 112]}}},
         {18=>{1=>{9=>[4, 7, 18, 112]},
               2=>{9=>[4, 4, 7, 18, 112]}}}],
    :uniq_profiles_pairs=>
        {20=>{1=>13, 2=>13},
         19=>{1=>7, 2=>7},
         62=>{1=>11, 2=>11},
         17=>{1=>8, 2=>8},
         18=>{1=>9, 2=>9}},
    :profiles_with_match_hash=>
        {9=>5, 8=>5, 7=>5, 11=>5, 13=>4},
    :by_profiles=>
        [{:search_profile_id=>18, :found_tree_id=>2, :found_profile_id=>9, :count=>5},
         {:search_profile_id=>18, :found_tree_id=>1, :found_profile_id=>9, :count=>5},
         {:search_profile_id=>17, :found_tree_id=>2, :found_profile_id=>8, :count=>5},
         {:search_profile_id=>17, :found_tree_id=>1, :found_profile_id=>8, :count=>5},
         {:search_profile_id=>19, :found_tree_id=>1, :found_profile_id=>7, :count=>5},
         {:search_profile_id=>62, :found_tree_id=>1, :found_profile_id=>11, :count=>5},
         {:search_profile_id=>19, :found_tree_id=>2, :found_profile_id=>7, :count=>5},
         {:search_profile_id=>62, :found_tree_id=>2, :found_profile_id=>11, :count=>5},
         {:search_profile_id=>20, :found_tree_id=>2, :found_profile_id=>13, :count=>4},
         {:search_profile_id=>20, :found_tree_id=>1, :found_profile_id=>13, :count=>4}],
    :by_trees=>
        [{:found_tree_id=>1, :found_profile_ids=>[13, 7, 11, 8, 9]},
         {:found_tree_id=>2, :found_profile_ids=>[13, 7, 11, 8, 9]}],
    :duplicates_one_to_many=>{}, :duplicates_many_to_one=>{}}
#
