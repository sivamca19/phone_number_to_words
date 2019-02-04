RSpec.describe PhoneNumberToWords do
  it 'has a version number' do
    expect(PhoneNumberToWords::VERSION).not_to be nil
  end

  before(:all) do
    @words = PhoneNumberToWords::Convert.new
  end
  context '#is_valid_no' do
    it 'return true for valid number' do
      expect(@words.is_valid_no('6686787825')).to be(true)
      expect(@words.is_valid_no('2282668687')).to be(true)
    end

    it 'return false for invalid number' do
      expect(@words.is_valid_no('')).to be(false)
      expect(@words.is_valid_no('1282068681')).to be(false)
      expect(@words.is_valid_no('66867878255')).to be(false)
    end
  end

  context '#generate_words' do
    it 'return error message for invalid number' do
      expect(@words.generate_words('')).to be_an_instance_of(String)
      expect(@words.generate_words('')).to eq(ERROR_MSG)

      expect(@words.generate_words('1282068681')).to be_an_instance_of(String)
      expect(@words.generate_words('66867878255')).to eq(ERROR_MSG)
    end

    it 'return array of words for valid number' do
      expect(@words.generate_words('6686787825')).to be_an_instance_of(Array)
      expect(@words.generate_words('2282668687')).to be_an_instance_of(Array)

      expect(@words.generate_words('6686787825').first).to include('noun')
      expect(@words.generate_words('6686787825').last).to eq('motortruck')

      expect(@words.generate_words('2282668687').first).to include('act')
      expect(@words.generate_words('2282668687').last).to eq('catamounts')

      expect(@words.generate_words('6686787825')).to eq([%w[noun struck],
                                                         %w[onto struck],
                                                         %w[motor truck],
                                                         %w[motor usual],
                                                         %w[nouns truck],
                                                         %w[nouns usual],
                                                         'motortruck'])
      expect(@words.generate_words('2282668687')).to eq([%w[act amounts],
                                                         %w[act contour],
                                                         %w[bat amounts],
                                                         %w[bat contour],
                                                         %w[cat amounts],
                                                         %w[cat contour],
                                                         %w[acta mounts],
                                                         'catamounts'])
    end
  end
end
