require 'telegram/bot'

class CovidBot
  def initialize
    @first_name = ''
    token = '1165981459:AAEsQhEuY-mWtry8-WBrdDg8IB0fc16CnAY'

    Telegram::Bot::Client.run(token) do |bot|
      bot.listen do |message|
        @first_name = message.from.first_name
        begin
            case message.text
            when '/start'
              bot.api.send_message(chat_id: message.chat.id, text: start_message)
            when '/stop'
              bot.api.send_message(chat_id: message.chat.id, text: stop_message, date: message.date)
            end
        rescue StandardError
          next
          end
      end
    end
  end

  private

  def display_stat(val)
    <<-HEARDOC

      Country: #{val[-1]['Country']}
      Code: #{val[-1]['CountryCode']}
      New Confirmed: #{val[-1]['NewConfirmed']}
      Total Confirmed: #{val[-1]['TotalConfirmed']}
      New Deaths: #{val[-1]['NewDeaths']}
      Total Deaths: #{val[-1]['TotalDeaths']}
      New Recovered: #{val[-1]['NewRecovered']}
      Total Recovered: #{val[-1]['TotalRecovered']}
      Active: #{val[-1]['TotalConfirmed'] - val[-1]['TotalRecovered']}
    HEARDOC
  end

  def start_message
    <<-HEARDOC
    Hello, #{@first_name} , welcome to motivation chat bot created by Mikael Araya
    the chat bot is to give you updated information for COVID-19 .
    Use  /start to start the bot,  /stop to end the bot, /help to get help.
    after starting the bot send the country name you want to get COVID-19 information or
    send global to get summary for global numbers
    HEARDOC
  end

  def stop_message
    <<-HEARDOC
    "Bye, #{@first_name}"
    HEARDOC
  end
end
