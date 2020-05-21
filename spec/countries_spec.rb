require './lib/countries.rb'

describe Countries do
  context '#generate_flag' do
    it 'Should return the correct URL' do
      expect(Countries.generate_flag('et')).to eq 'https://www.countryflags.io/et/shiny/64.png'
    end
  end
end
