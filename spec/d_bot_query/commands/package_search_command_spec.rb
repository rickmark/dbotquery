# frozen_string_literal: true

RSpec.describe DBotQuery::Commands::PackageSearchCommand, type: :command do
  let(:fixed_results) do
    JSON.load_file(File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'package_search_result.json'),
                   symbolize_names: true)
  end

  it "returns the valid results for 'nokogiri'" do
    command = described_class.new(package: 'nokogiri')
    command.execute!(input_file)

    expect(command.result).to eq(fixed_results)
  end
end
