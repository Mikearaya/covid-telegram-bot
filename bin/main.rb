#!/usr/bin/env ruby
require_relative '../lib/covid_bot.rb'
require_relative '../lib/countries.rb'

# rubocop: disable Metrics/BlockLength

def handle_inline_query(bot, message)
  return unless message.query.size > 1

  newbot = CovidBot.new(message.from.first_name, message.query, message.from.username)
  query_result = newbot.inline_query(message.query)

  results = query_result.map do |arr|
    Telegram::Bot::Types::InlineQueryResultArticle.new(
      id: arr[:id],
      title: arr[:name],
      thumb_url: arr[:flag],
      thumb_width: 100,
      thumb_height: 200,
      input_message_content: Telegram::Bot::Types::InputTextMessageContent
      .new(message_text: newbot.display_stat(arr[:stat]))
    )
  end

  bot.api.answer_inline_query(inline_query_id: message.id, results: results)
  puts newbot.log_request
end

Telegram::Bot::Client.run(CovidBot::TOKEN) do |bot|
  bot.listen do |message|
    id = nil
    begin
      if message.instance_of?(Telegram::Bot::Types::InlineQuery)
        handle_inline_query(bot, message)
      elsif message.instance_of?(Telegram::Bot::Types::Message)
        id = message.chat.id
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
      unless id.nil?
        bot.api.send_message(chat_id: id, text: 'Sorry about that, can you enter again, and
          check for spelling errors this time :-)')
      end
      next
    end
  end
end
# rubocop: enable Metrics/BlockLength
