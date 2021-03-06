require './lib/covid_bot.rb'
require 'json'
describe CovidBot do
  subject { CovidBot.new(first_name.to_s, message.to_s, username.to_s) }
  country_result = {
    'Country' => 'Ethiopia',
    'CountryCode' => 'ET',
    'NewConfirmed' => 11,
    'TotalConfirmed' => 340,
    'NewDeaths' => 0,
    'TotalDeaths' => 5,
    'NewRecovered' => 1,
    'TotalRecovered' => 119
  }

  global_result = {
    'NewConfirmed' => 111_111,
    'TotalConfirmed' => 344_444,
    'NewDeaths' => 1_000_000,
    'TotalDeaths' => 2_000_000,
    'NewRecovered' => 4000,
    'TotalRecovered' => 40_000
  }

  context 'Initialized correctly' do
    let(:first_name) { 'Mikael' }
    let(:message) { 'ethiopia' }
    let(:username) { 'starboy_12' }
    it { is_expected.to have_attributes(first_name: 'Mikael', message: 'ethiopia', username: 'starboy_12') }

    it 'Should have correct TOKEN key' do
      expect(CovidBot::TOKEN).to eq '1165981459:AAEsQhEuY-mWtry8-WBrdDg8IB0fc16CnAY'
    end
  end

  context '#start_message should' do
    let(:first_name) { 'Mikael' }
    let(:message) { 'ethiopia' }
    let(:username) { 'starboy_12' }
    it 'display message for current user name' do
      expect(subject.start_message).to match(/mikael/i)
    end
    it 'display message /start instruction' do
      expect(subject.start_message).to match(%r{/start}i)
    end
    it 'display message /stop instruction' do
      expect(subject.start_message).to match(%r{/stop}i)
    end
    it 'display message /help instruction' do
      expect(subject.start_message).to match(%r{/help}i)
    end
    it 'display message /search instruction' do
      expect(subject.start_message).to match(%r{/search}i)
    end
    it 'display message country name instruction' do
      expect(subject.start_message).to match(/country name/i)
    end
    it 'display message country code instruction' do
      expect(subject.start_message).to match(/country code/i)
    end
    it 'display message global instruction' do
      expect(subject.start_message).to match(/global/i)
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
      expect(subject.display_stat(country_result)).to match(/country: ethiopia/i)
    end

    it 'display country code' do
      expect(subject.display_stat(country_result)).to match(/code: ET/i)
    end

    it 'display New confirmed' do
      expect(subject.display_stat(country_result)).to match(/new confirmed: 11/i)
    end

    it 'display total confirmed' do
      expect(subject.display_stat(country_result)).to match(/total confirmed: 340/i)
    end

    it 'display New deaths' do
      expect(subject.display_stat(country_result)).to match(/new deaths: 0/i)
    end

    it 'display total deaths' do
      expect(subject.display_stat(country_result)).to match(/total deaths: 5/i)
    end

    it 'display New recovered' do
      expect(subject.display_stat(country_result)).to match(/new recovered: 1/i)
    end

    it 'display total recovered' do
      expect(subject.display_stat(country_result)).to match(/total recovered: 119/i)
    end

    it 'display active' do
      expect(subject.display_stat(country_result)).to match(/active: 221/i)
    end
  end

  context '#display_global_stat should' do
    let(:first_name) { 'Mikael' }
    let(:message) { 'ethiopia' }
    let(:username) { 'starboy_12' }

    it 'display New confirmed' do
      expect(subject.display_stat(global_result)).to match(/new confirmed: 11111/i)
    end

    it 'display total confirmed' do
      expect(subject.display_stat(global_result)).to match(/total confirmed: 344444/i)
    end

    it 'display New deaths' do
      expect(subject.display_stat(global_result)).to match(/new deaths: 1000000/i)
    end

    it 'display total deaths' do
      expect(subject.display_stat(global_result)).to match(/total deaths: 2000000/i)
    end

    it 'display New recovered' do
      expect(subject.display_stat(global_result)).to match(/new recovered: 4000/i)
    end

    it 'display total recovered' do
      expect(subject.display_stat(global_result)).to match(/total recovered: 40000/i)
    end

    it 'display active' do
      expect(subject.display_stat(global_result)).to match(/active: 304444/i)
    end
  end

  context '#stop_message should' do
    let(:first_name) { 'Mikael' }
    let(:message) { 'ethiopia' }
    let(:username) { 'starboy_12' }

    it 'include first name' do
      expect(subject.stop_message).to match(/mikael/i)
    end

    it 'include bye' do
      expect(subject.stop_message).to match(/bye/i)
    end
  end
end
