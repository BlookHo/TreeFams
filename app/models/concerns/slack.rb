module Slack
  extend ActiveSupport::Concern


  def send_new_pending_user_message_to_slack
    system(' curl -X POST --data-urlencode \'payload={"channel": "#general", "username": "WeAllFamily Bot", "text": "Новый пользователь ожидает модерации. Для утверждения зайдит в административную панель сайта.", "icon_emoji": ":ghost:"}\' https://hooks.slack.com/services/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 ')
  end

  # curl -X POST --data-urlencode 'payload={"channel": "#general", "username": "WeAllFamily Bot", "text": "Новый пользователь ожидает модерации. Для утверждения, <http://weallfamily.ru/admin/pending_users|нажмите здесь>", "icon_emoji": ":ghost:"}' https://hooks.slack.com/services/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


end
