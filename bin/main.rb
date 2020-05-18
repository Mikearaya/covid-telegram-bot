#!/usr/bin/env ruby
require_relative '../lib/covid_bot.rb'

def handle_inline_query(bot, message)
  newbot = CovidBot.new(message.from.first_name, message.query, message.from.username)
  query_result = newbot.inline_query(message.query)

  results = query_result.map do |arr|
    Telegram::Bot::Types::InlineQueryResultArticle.new(
      id: arr[0],
      title: arr[1],
      input_message_content: Telegram::Bot::Types::InputTextMessageContent
      .new(message_text: newbot.display_stat(arr[2]))
    )
  end

  bot.api.answer_inline_query(inline_query_id: message.id, results: results)
  puts newbot.log_request
end

Telegram::Bot::Client.run(CovidBot::TOKEN) do |bot|
  bot.listen do |message|
    begin
      if message.instance_of?(Telegram::Bot::Types::InlineQuery)
        handle_inline_query(bot, message)
      elsif message.instance_of?(Telegram::Bot::Types::Message)
        newbot = CovidBot.new(message.from.first_name, message.text, message.from.username)
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
        puts newbot.log_request
      end
    rescue StandardError => e
      puts e.message
      next
    end
  end
end
