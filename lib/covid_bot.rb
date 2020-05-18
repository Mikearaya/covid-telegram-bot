require 'telegram/bot'
require_relative './covid_api.rb'
class CovidBot
  TOKEN = '1165981459:AAEsQhEuY-mWtry8-WBrdDg8IB0fc16CnAY'.freeze
  attr_reader :first_name, :message, :username

  def initialize(first_name, message, username)
    @first_name = first_name.to_s
    @message = message
    @username = username.to_s
    @covid_api = CovidAPI.new
  end

  def country_stat(country)
    raise unless CovidAPI.country_exists(country)

    @covid_api.by_country(country)
  end

  def global_stat
    @covid_api.global
  end

  def display_country_list(text)
    @covid_api.supported_countries(text)
  end

  def inline_query(query)
    @covid_api.query_result(query)
  end

  def display_stat(val)
    <<~HEARDOC

      Country: #{val['Country']}
      Code: #{val['CountryCode']}
                Confirmed
      New Confirmed: #{val['NewConfirmed']}
      Total Confirmed: #{val['TotalConfirmed']}

                Deaths
      New Deaths: #{val['NewDeaths']}
      Total Deaths: #{val['TotalDeaths']}

                Recovered
      New Recovered: #{val['NewRecovered']}
      Total Recovered: #{val['TotalRecovered']}

                Active
      Active: #{val['TotalConfirmed'] - val['TotalRecovered']}
    HEARDOC
  end

  def display_global_stat(val)
    <<~HEARDOC
                    GLOBAL

                Confirmed
      New Confirmed: #{val['NewConfirmed']}
      Total Confirmed: #{val['TotalConfirmed']}
                Deaths
      New Deaths: #{val['NewDeaths']}
      Total Deaths: #{val['TotalDeaths']}
                Recovered
      New Recovered: #{val['NewRecovered']}
      Total Recovered: #{val['TotalRecovered']}
                Active
      Active: #{val['TotalConfirmed'] - val['TotalRecovered']}
    HEARDOC
  end

  def start_message
    <<~HEARDOC
      Hello, #{@first_name} , welcome to Bionic COVID-19 chat bot created by Mikael Araya
      the bot is created to give you updated information for COVID-19 .
      Use
      /start to start the bot

      After starting the bot send (country name eg: ethiopia or country code eg: et for ethiopia)
      to get COVID-19 information or send global to get summary for global numbers

      More Commands

      /stop to end the bot
      /help to get helpful information
      /search search term, to serch supported countries list
    HEARDOC
  end

  def help_manual
    <<~HEARDOC
      Enter the following to interact with the bot:
      -> Country name or country code to get latest statistics of the country
        example: sending ethiopia or et will get you latest numbers of cases in ethiopia
      -> Global to get total global cases
      -> /search [search term] to search for supported countries
      -> /stop to stop the bot
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
