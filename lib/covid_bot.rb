require 'telegram/bot'
require_relative './covid_api.rb'
class CovidBot
  TOKEN = '1165981459:AAEsQhEuY-mWtry8-WBrdDg8IB0fc16CnAY'.freeze
  attr_reader :first_name, :message, :username

  def initialize(first_name, message, username)
    @first_name = first_name
    @message = message
    @username = username
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
    result = @covid_api.supported_countries(text)
    if result.size.zero?
      return "I couldn't find a country that match ( #{text})
              :-(, let's try another"
    end
    countries = ''
    result.each do |country|
      if country[:name].downcase.match?(text.downcase) || country[:code].downcase.match?(text.downcase)
        countries += "#{country[:name]} --- code: #{country[:code]} \n"
      end
    end
    countries
  end

  def inline_query(query)
    @covid_api.query_result(query)
  end

  def display_stat(val)
    <<~HEARDOC

      Country: #{val['Name']}
      Code: #{val['CountryInfo']['CountryCode']}

                Confirmed
      New Confirmed: #{val['TodayCases']}
      Total Confirmed: #{val['TotalCases']}

                Critical
      Critical: #{val['Critical']}

                Deaths
      New Deaths: #{val['TodayDeaths']}
      Total Deaths: #{val['TotalDeaths']}

                Recovered
      Recovered: #{val['Recovered']}

                Active
      Active: #{val['TotalCases'] - val['Recovered']}
    HEARDOC
  end

  def display_global_stat(val)
    <<~HEARDOC
        GLOBAL

                Confirmed
      New Confirmed: #{val['TotalCasesToday']}
      Total Confirmed: #{val['TotalCases']}

                  Deaths
      New Deaths: #{val['TotalDeathsToday']}
      Total Deaths: #{val['TotalDeaths']}

                Recovered
      Total Recovered: #{val['TotalRecovered']}

                Affected Countries
            #{val['TotalTerritories']}

                Active
      Active: #{val['TotalCases'] - val['TotalRecovered']}
    HEARDOC
  end

  def start_message
    <<~HEARDOC
      Hello, #{@first_name} , welcome to Bionic COVID-19 chat bot created by Mikael Araya
      the bot is created to give you updated information for COVID-19 .
      Use

      /start to start the bot

      After starting the bot send
      - country name (eg: ethiopia)
      - country code (eg: et for ethiopia)
      - global to get summary for global numbers

      to get COVID-19 information

      More Commands
      /stop to end the bot
      /help to get helpful information
      /search search term, to serch supported countries list

      You can also use this bot anywhere inside telegram by typing @bionic_covid_bot
        and searching for country you want statistics for
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
      -> you can use this bot anywhere inside telegram by typing @bionic_covid_bot
          and searching for country you want statistics for
    HEARDOC
  end

  def stop_message
    <<~HEARDOC
      "Bye, #{@first_name}"
    HEARDOC
  end

  def log_request(type = 'message')
    '[' + type + '] ' + @first_name + ' ' + @message + ' ' + @username
  end
end
