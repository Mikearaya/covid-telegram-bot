require_relative '../lib/covid_bot.rb'

Telegram::Bot::Client.run(CovidBot.TOKEN) do |bot|
  bot.listen do |message|
    newbot = CovidBot.new(message.from.first_name, message.text, message.from.username)
    begin
      case message.text
      when '/start'
        bot.api.send_message(chat_id: message.chat.id, text: newbot.start_message)
      when '/stop'
        bot.api.send_message(chat_id: message.chat.id, text: newbot.stop_message, date: message.date)
      else

        unless values.country_exists(message.text)
          bot.api.send_message(chat_id: message.chat.id, text: 'AGAIN', date: message.date)
          next
        end
        puts newbot.log_request
        value = values.get_country(message.text)
        bot.api.send_message(chat_id: message.chat.id, text: display_stat(value), date: message.date)
      end
    rescue StandardError => e
      puts e.message
      bot.api.send_message(chat_id: message.chat.id, text: 'Sorry Again')
      next
    end
  end
end
