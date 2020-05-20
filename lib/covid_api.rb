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
    @summary = make_the_request
    val = @summary['Countries'].select do |country|
      country['Country'].downcase == search.to_s.downcase ||
        country['CountryCode'].downcase == search.to_s.downcase
    end
    val
  end

  def query_result(search = '')
    @summary = make_the_request
    val = @summary['Countries'].select do |country|
      country['Country'].downcase.match?(search.to_s.downcase) ||
        country['CountryCode'].downcase.match?(search.to_s.downcase)
    end

    results = []
    val.each_with_index do |item, i|
      results << { id: i, name: item['Country'], stat: item, flag: Countries.generate_flag(item['CountryCode']) }
    end
    results
  end

  def global
    @summary = make_the_request
    @summary['Global']
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

  def make_the_request
    url = 'https://api.covid19api.com/summary'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    response = JSON.parse(response)
    response
  end
end
