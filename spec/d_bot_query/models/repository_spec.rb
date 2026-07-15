RSpec.describe DBotQuery::Models::Repository do
  let(:repository) { described_class.new(full_name: 'dogexchange/blocklinklib') }
  let(:repository_same_name) { described_class.new(full_name: 'dogexchange/blocklinklib') }

  it 'has a full_name' do
    expect(repository.full_name).not_to be_nil
  end

  describe '#==' do
    it 'is equal to one of the same name' do
      expect(repository).to eq(repository_same_name)
    end

    it 'is equal to its full name' do
      expect(repository).to eq('dogexchange/blocklinklib')
    end

    it 'is not equal to other things' do
      expect(repository).not_to eq(1)
    end
  end
end
