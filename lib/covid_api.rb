require 'telegram/bot'
require 'net/http'
require 'json'
require_relative 'countries.rb'

class CovidAPI
  include Countries

  def initialize; end

  def self.country_exists(search = '')
    val = false

    unless search.nil?
      COUNTRIES.any? do |country|
        val = true if country[:name].downcase == search.to_s.downcase || country[:code].downcase == search.to_s.downcase
      end
    end
    val
  end

  def by_country(search)
    @summary = countries_request
    val = @summary.select do |country|
      country['Name'].downcase == search.to_s.downcase ||
        country['CountryInfo']['CountryCode'].downcase == search.to_s.downcase
    end
    val
  end

  def query_result(search = '')
    @summary = countries_request
    val = @summary.select do |country|
      country['Name'].downcase.match?(search.to_s.downcase) ||
        country['CountryInfo']['CountryCode'].downcase.match?(search.to_s.downcase)
    end

    results = []
    val.each_with_index do |item, i|
      results << { id: i, name: item['Name'],
                   stat: item,
                   flag: Countries.generate_flag(item['CountryInfo']['CountryCode']) }
    end
    results
  end

  def global
    @summary = summary_request
  end

  def supported_countries(text = '')
    countries = []
    COUNTRIES.each do |country|
      if country[:name].downcase.match?(text.downcase) || country[:code].downcase.match?(text.downcase)
        countries << country
      end
    end
    countries
  end

  private

  def summary_request
    url = 'http://corona.tuply.co.za/DataHandler.ashx?w=s&uq=k53mx8qtuvh641172'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    response = JSON.parse(response)
    response
  end

  def countries_request
    url = 'http://corona.tuply.co.za/DataHandler.ashx?w=c&s=c'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    response = JSON.parse(response)
    response
  end
end
