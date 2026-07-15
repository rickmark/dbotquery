# frozen_string_literal: true

module DBotQuery
  module Models
    # A singular dependency alert
    class Alert < Base
      attribute :number, :integer
      alias_attribute :id, :number
      delegate :severity, to: :security_vulnerability

      attribute :repository, Repository
      attribute :dependency, Dependency
      attribute :security_advisory, SecurityAdvisory
      attribute :security_vulnerability, SecurityVulnerability

      attribute :created_at, :datetime
      attribute :updated_at, :datetime
      attribute :dismissed_at, :datetime
      attribute :fixed_at, :datetime
      attribute :auto_dismissed_at, :datetime
      attribute :state, :symbol
      attribute :url, :url
      attribute :html_url, :url
      attribute :dismissed_by, :string
      attribute :dismissed_comment, :string
      attribute :dismissed_reason, :string
      attribute :dismissal_request
      attribute :assignees, :array, of: String

      def days_open(as_of)
        as_of = as_of&.to_date || Time.now.to_date
        create_date = created_at.to_date
        if (fix_date = fixed_at)
          fix_date = fix_date.to_date
          fix_date < as_of ? (fix_date - create_date).to_i : (as_of - create_date).to_i
        else
          (as_of - create_date).to_i
        end
      end
    end
  end
end
