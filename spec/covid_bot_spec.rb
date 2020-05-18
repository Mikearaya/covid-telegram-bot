require './lib/covid_bot.rb'
describe CovidBot do
  subject { CovidBot.new(first_name.to_s, message.to_s, username.to_s) }
  context 'Initialized correctly' do
    let(:first_name) { 'Mikael' }
    let(:message) { 'ethiopia' }
    let(:username) { 'starboy_12' }
    it { is_expected.to have_attributes(first_name: 'Mikael', message: 'ethiopia', username: 'starboy_12') }
  end
end
