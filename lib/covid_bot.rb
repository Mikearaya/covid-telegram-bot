require 'telegram/bot'
require_relative './covid_api.rb'
class CovidBot
  TOKEN = '1165981459:AAEsQhEuY-mWtry8-WBrdDg8IB0fc16CnAY'.freeze

  def initialize(first_name, message, username)
    @first_name = first_name
    @message = message
    @username = username
    @covid_api = CovidAPI.new
  end

  def get_country_stat(country)
    raise unless CovidAPI.country_exists(country)

    @covid_api.get_country(country)
  end

  def display_stat(val)
    <<~HEARDOC

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
    <<~HEARDOC
      Hello, #{@first_name} , welcome to motivation chat bot created by Mikael Araya
      the chat bot is to give you updated information for COVID-19 .
      Use  /start to start the bot,  /stop to end the bot, /help to get help.
      after starting the bot send the country name you want to get COVID-19 information or
      send global to get summary for global numbers
    HEARDOC
  end

  def stop_message
    <<~HEARDOC
      "Bye, #{@first_name}"
    HEARDOC
  end

  def log_request
    @first_name + ' ' + @message + ' ' + @username
  end
end
