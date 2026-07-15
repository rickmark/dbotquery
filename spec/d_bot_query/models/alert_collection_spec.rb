RSpec.describe DBotQuery::Models::AlertCollection do
  it 'fails when alerts is not parsable' do
    expect do
      described_class.new(alerts: ['invalid'])
    end.to raise_error(ArgumentError)
  end
end
