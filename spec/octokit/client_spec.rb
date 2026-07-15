RSpec.describe Octokit::Client do
  let(:client) { described_class.new access_token: ENV.fetch('GITHUB_TOKEN', nil) }

  it 'gathers org alerts' do
    expect(client.dependabot_org_alerts('hack-different')).to be_a(DBotQuery::Models::AlertCollection)
  end
end
