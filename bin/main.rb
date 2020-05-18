#!/usr/bin/env ruby
require_relative '../lib/covid_bot.rb'

Telegram::Bot::Client.run(CovidBot::TOKEN) do |bot|
  bot.listen do |message|
    newbot = CovidBot.new(message.from.first_name, message.text, message.from.username)
    begin
      puts newbot.log_request
      case message.text.to_s.downcase
      when '/start'
        bot.api.send_message(chat_id: message.chat.id, text: newbot.start_message)
      when '/stop'
        bot.api.send_message(chat_id: message.chat.id, text: newbot.stop_message, date: message.date)
      when '/help'
        bot.api.send_message(chat_id: message.chat.id, text: newbot.help_manual, date: message.date)
      when %r{^/search}
        text = message.text.split(' ')
        bot.api.send_message(chat_id: message.chat.id, text: newbot.display_country_list(text[1]), date: message.date)
      when 'global'
        value = newbot.global_stat
        bot.api.send_message(chat_id: message.chat.id, text: newbot.display_global_stat(value), date: message.date)
      else
        value = newbot.country_stat(message.text)
        bot.api.send_message(chat_id: message.chat.id, text: newbot.display_stat(value[0]), date: message.date)
      end
    rescue StandardError => e
      puts e.message
      bot.api.send_message(chat_id: message.chat.id, text: 'Sorry about that, can you enter again, and
        check for spelling errors this time :-)')
      next
    end
  end
end
