# frozen_string_literal: true

RSpec.describe DBotQuery::Models::DataFile do
  it 'loads from data' do
    data = File.read('spec/fixtures/dependabot.json')
    collection = described_class.load data
    expect(collection.alerts.count).to eq(120)
  end

  it 'loads from a file' do
    collection = described_class.load_file 'spec/fixtures/dependabot.json'
    expect(collection.alerts.count).to eq(120)
  end
end
