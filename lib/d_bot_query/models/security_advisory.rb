# frozen_string_literal: true

module DBotQuery
  module Models
    # The backing security advisory that triggered the alert
    class SecurityAdvisory < Base
      attribute :ghsa_id, :string
      attribute :cve_id, :string
      attribute :summary, :string
      attribute :description, :string
      attribute :severity, :symbol
      attribute :published_at, :datetime
      attribute :updated_at, :datetime
      attribute :withdrawn_at, :datetime
      attribute :identifiers, :array, of: VulnerabilityIdentifier
      attribute :references, :array, of: Reference
      attribute :vulnerabilities, :array, of: SecurityVulnerability
      attribute :cvss, CVSS
      attribute :cvss_severities, :array, of: CVSSSeverity
      attribute :cwes, :array, of: CWE
      attribute :epss
      attribute :classification
    end
  end
end
