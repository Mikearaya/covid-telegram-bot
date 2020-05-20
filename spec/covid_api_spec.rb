require './lib/covid_api.rb'
describe CovidAPI do
  subject { CovidAPI.new }
  single_country_result = { 'Countries' =>
        [{
          'Country' => 'ethiopia',
          'CountryCode' => 'ET'
        }] }
  global_result = { 'Global' => {
    'NewConfirmed' => 111_111,
    'TotalConfirmed' => 344_444,
    'NewDeaths' => 1_000_000,
    'TotalDeaths' => 2_000_000,
    'NewRecovered' => 4000,
    'TotalRecovered' => 40_000
  } }

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

  context '#query_result should' do
    it 'return and array' do
      allow(subject).to receive(:make_the_request).and_return(single_country_result)

      result = subject.query_result('et')
      expect(result).to be_instance_of(Array)
    end
    it 'return and array of elements' do
      allow(subject).to receive(:make_the_request).and_return(single_country_result)

      result = subject.query_result('et')
      expect(result.size).to be > 0
    end

    it 'return and 0 elements when no match is found' do
      allow(subject).to receive(:make_the_request).and_return(single_country_result)

      result = subject.query_result('zzzz')
      expect(result.size).to eq 0
    end
  end

  context '#global should' do
    it 'return Hash' do
      allow(subject).to receive(:make_the_request).and_return(global_result)
      result = subject.global
      expect(result).to be_instance_of(Hash)
    end
  end

  context '#supported_countries should' do
    it 'return Array' do
      expect(subject.supported_countries('e')).to be_instance_of(Array)
    end

    it 'return Array of matching countries' do
      expect(subject.supported_countries('e').size).to be > 0
    end
    it 'return empty Array when no match is found' do
      expect(subject.supported_countries('zzzz').size).to eq 0
    end
  end
end
