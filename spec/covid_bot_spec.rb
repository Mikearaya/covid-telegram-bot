require './lib/covid_bot.rb'
require 'json'
describe CovidBot do
  subject { CovidBot.new(first_name.to_s, message.to_s, username.to_s) }
  result = {
    'Country' => 'Ethiopia',
    'CountryCode' => 'ET',
    'NewConfirmed' => 11,
    'TotalConfirmed' => 340,
    'NewDeaths' => 0,
    'TotalDeaths' => 5,
    'NewRecovered' => 1,
    'TotalRecovered' => 119
  }
  context 'Initialized correctly' do
    let(:first_name) { 'Mikael' }
    let(:message) { 'ethiopia' }
    let(:username) { 'starboy_12' }
    it { is_expected.to have_attributes(first_name: 'Mikael', message: 'ethiopia', username: 'starboy_12') }
  end

  context '#start_message should' do
    let(:first_name) { 'Mikael' }
    let(:message) { 'ethiopia' }
    let(:username) { 'starboy_12' }
    it 'should display message for current user name' do
      expect(subject.start_message).to match(/mikael/i)
    end
  end

  context '#log_request should' do
    let(:first_name) { 'Mikael' }
    let(:message) { 'ethiopia' }
    let(:username) { 'starboy_12' }
    it 'log current user name' do
      expect(subject.log_request).to match(/mikael/i)
    end
    it 'log current username' do
      expect(subject.log_request).to match(/starboy_12/i)
    end
    it 'log current message' do
      expect(subject.log_request).to match(/ethiopia/i)
    end
  end

  context '#display_stat should' do
    let(:first_name) { 'Mikael' }
    let(:message) { 'ethiopia' }
    let(:username) { 'starboy_12' }
    it 'display country name' do
      expect(subject.display_stat(result)).to match(/country: ethiopia/i)
    end

    it 'display country code' do
      expect(subject.display_stat(result)).to match(/code: ET/i)
    end

    it 'display New confirmed' do
      expect(subject.display_stat(result)).to match(/new confirmed: 11/i)
    end

    it 'display total confirmed' do
      expect(subject.display_stat(result)).to match(/total confirmed: 340/i)
    end

    it 'display New deaths' do
      expect(subject.display_stat(result)).to match(/new deaths: 0/i)
    end

    it 'display total deaths' do
      expect(subject.display_stat(result)).to match(/total deaths: 5/i)
    end

    it 'display New recovered' do
      expect(subject.display_stat(result)).to match(/new recovered: 1/i)
    end

    it 'display total recovered' do
      expect(subject.display_stat(result)).to match(/total recovered: 119/i)
    end

    it 'display active' do
      expect(subject.display_stat(result)).to match(/active: 221/i)
    end
  end
end
