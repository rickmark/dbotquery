# frozen_string_literal: true

RSpec.describe DBotQuery::Models::Alert do
  subject(:alert) { described_class.new(attributes) }

  let(:attributes) do
    {
      number: 357,
      state: 'fixed',
      dependency: {
        package: { ecosystem: 'npm', name: 'node-forge' },
        manifest_path: 'package-lock.json',
        scope: nil
      },
      security_advisory: { ghsa_id: 'GHSA-gf8q-jrpm-jvxq', severity: 'low' },
      security_vulnerability: { package: { ecosystem: 'npm', name: 'node-forge' }, severity: 'low' },
      url: 'https://api.github.com/repos/dogexchange/lib/dependabot/alerts/357',
      html_url: 'https://github.com/dogexchange/lib/security/dependabot/357',
      created_at: '2022-01-31T16:34:20Z',
      updated_at: '2022-03-02T12:57:58Z',
      fixed_at: '2022-03-02T12:57:58Z'
    }
  end

  describe 'attribute casting' do
    it 'casts number to an integer' do
      expect(described_class.new(number: '357').number).to eq(357)
    end

    it 'expects the ID to match' do
      expect(alert.id).to eq(357)
    end

    it 'aliases id to number' do
      aggregate_failures do
        expect(alert.id).to eq(357)
        expect(alert.id).to eq(alert.number)
      end
    end

    it 'casts state to a symbol' do
      expect(alert.state).to eq(:fixed)
    end

    it 'casts timestamps to datetimes' do
      aggregate_failures do
        expect(alert.created_at).to be_a(Time).or be_a(DateTime)
        expect(alert.created_at.to_date).to eq(Date.new(2022, 1, 31))
        expect(alert.fixed_at.to_date).to eq(Date.new(2022, 3, 2))
      end
    end

    it 'leaves absent timestamps nil' do
      aggregate_failures do
        expect(alert.dismissed_at).to be_nil
        expect(alert.auto_dismissed_at).to be_nil
      end
    end

    it 'builds nested model instances' do
      aggregate_failures do
        expect(alert.dependency).to be_a(DBotQuery::Models::Dependency)
        expect(alert.security_advisory).to be_a(DBotQuery::Models::SecurityAdvisory)
        expect(alert.security_vulnerability).to be_a(DBotQuery::Models::SecurityVulnerability)
      end
    end

    it 'casts url attributes into addressable templates' do
      aggregate_failures do
        expect(alert.url).to be_a(Addressable::Template)
        expect(alert.url.pattern).to eq(attributes[:url])
      end
    end
  end

  describe '#severity' do
    it 'delegates to the security vulnerability' do
      aggregate_failures do
        expect(alert.severity).to eq(:low)
        expect(alert.severity).to eq(alert.security_vulnerability.severity)
      end
    end
  end

  describe '#days_open' do
    context 'when the alert has been fixed' do
      it 'measures from created_at to fixed_at and ignores as_of (when later)' do
        # 2022-01-31 -> 2022-03-02 spans 30 days (Feb has 28 days in 2022).
        expect(alert.days_open(Date.new(2030, 1, 1))).to eq(30)
      end

      it 'measures from created_at to as_of when before fixed_at' do
        expect(alert.days_open(Date.new(2022, 2, 10))).to eq(10)
      end
    end

    context 'when the alert is still open' do
      subject(:alert) { described_class.new(attributes.except(:fixed_at).merge(state: :open)) }

      it 'measures from created_at to the provided as_of date' do
        expect(alert.days_open(Date.new(2022, 2, 10))).to eq(10)
      end

      it 'measures from created_at and continues' do
        # 2022-01-31 -> 2022-03-02 spans 30 days (Feb has 28 days in 2022).
        expect(alert.days_open(Date.new(2030, 1, 1))).to eq(2892)
      end

      it 'accepts a Time as as_of' do
        expect(alert.days_open(Time.utc(2022, 2, 10, 12))).to eq(10)
      end

      it 'defaults to today when as_of is nil' do
        expected = (Time.now.to_date - Date.new(2022, 1, 31)).to_i
        expect(alert.days_open(nil)).to eq(expected)
      end
    end
  end

  describe 'loading from fixtures' do
    let(:collection) { DBotQuery::Models::DataFile.load_file('spec/fixtures/dependabot.json') }

    describe 'populates alerts parsed from real dependabot data' do
      let(:alert) { collection.alerts.find { |candidate| candidate.number == 357 } }

      it 'is non-null' do
        expect(alert).not_to be_nil
      end

      it 'has #state' do
        expect(alert.state).to eq(:fixed)
      end

      it 'has #severity' do
        expect(alert.severity).to eq(:low)
      end

      it 'has #dependency with a valid package' do
        expect(alert.dependency.package).to eq('node-forge')
      end
    end
  end

  describe '#to_h' do
    let(:hash) { alert.to_h }

    it 'serializes a URL' do
      expect(hash['url']).to eq('https://api.github.com/repos/dogexchange/lib/dependabot/alerts/357')
    end

    it 'serializes the state' do
      expect(hash['state']).to eq('fixed')
    end
  end
end
