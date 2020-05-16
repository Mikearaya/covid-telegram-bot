require 'telegram/bot'
require 'net/http'
require 'json'
require_relative 'countries.rb'

class CovidAPI
  @values = nil
  include Countries

  def initialize
    @summary = make_the_request
  end

  def country_exists(search = '')
    val = false

    unless search.nil?
      COUNTRIES.any? do |country|
        val = true if country[:name].downcase == search.to_s.downcase || country[:code].downcase == search.to_s.downcase
      end
    end
    val
  end

  def make_the_request
    url = 'https://api.covid19api.com/summary'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    response = JSON.parse(response)
    response
  end

  def get_country(search)
    val = @summary['Countries'].select do |country|
      country['Country'].downcase == search.to_s.downcase
    end
    val
  end
end
