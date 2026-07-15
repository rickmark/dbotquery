RSpec.describe DBotQuery::Models::Package do
  let(:package) { described_class.new(ecosystem: 'npm', name: 'test') }
  let(:duplicate_package) { described_class.new(ecosystem: 'npm', name: 'test') }
  let(:other_package) { described_class.new(ecosystem: 'npm', name: 'other') }

  describe '#==' do
    it 'equals two identical packages' do
      expect(package).to eq(duplicate_package)
    end

    it 'equals with just the name' do
      expect(package).to eq('test')
    end

    it 'is not equal to another package' do
      expect(package).not_to eq(other_package)
    end

    it 'is not equal to other types' do
      expect(package).not_to eq(1)
    end
  end
end
