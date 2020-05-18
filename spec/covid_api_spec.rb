require './lib/covid_api.rb'
describe CovidAPI do
  subject { CovidAPI.new }
  single_country_result = { 'Countries' =>
        [{
          'Country' => 'ethiopia',
          'CountryCode' => 'ET'
        }] }

  context '#country_exists should' do
    it 'result true when country exists' do
      expect(CovidAPI.country_exists('ethiopia')).to be_truthy
    end
    it 'result false when country doesn\'t exists' do
      expect(CovidAPI.country_exists('zzzzz')).to be_falsey
    end
    it 'result false when no text is not given' do
      expect(CovidAPI.country_exists).to be_falsey
    end
    it 'result false when Nil is given' do
      expect(CovidAPI.country_exists(nil)).to be_falsey
    end
  end

  context '#by_country should' do
    it 'result true when country exists' do
      allow(subject).to receive(:make_the_request).and_return(single_country_result)

      country = subject.by_country('ethiopia')
      expect(country[0]['Country']).to match(/^ethiopia$/i)
    end

    it 'result true when country code exists' do
      allow(subject).to receive(:make_the_request).and_return(single_country_result)

      country = subject.by_country('et')
      expect(country[0]['Country']).to match(/^ethiopia$/i)
    end

    it 'result [] when country doesn\'t exists' do
      allow(subject).to receive(:make_the_request).and_return(single_country_result)
      country = subject.by_country('zzzzz')
      expect(country.size.zero?).to be_truthy
    end
  end
end
