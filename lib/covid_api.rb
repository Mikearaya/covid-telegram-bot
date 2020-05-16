require 'telegram/bot'
require 'net/http'
require 'json'
require_relative 'countries.rb'

class CovidAPI
  @values = nil
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
      country['Country'].downcase == search.to_s.downcase || country['CountryCode'].downcase == search.to_s.downcase
    end
    val
  end

  def global
    @summary = make_the_request
    @summary['Global']
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
