# frozen_string_literal: true

# Namespace containing models for DBotQuery when used solely
# as an API.
module DBotQuery
  module Models
    # Class representing a collection of alerts.  This is usually the
    # result of deserializing JSON data.
    class AlertCollection
      include Enumerable

      delegate :each, to: :@alerts

      def initialize(alerts)
        @alerts = alerts.map do |alert|
          case alert
          when Hash
            Alert.new(alert)
          when Alert
            alert
          else
            raise ArgumentError, "Input of type #{alert.class} cannot be converted to Alert\n#{alert.inspect}"
          end
        end
      end

      def package_search(package_name)
        where_package(package_name).map { |alert| alert.repository.full_name }.uniq
      end

      def sla_violations(as_of = nil)
        # Here we select only those which are in violation of the SLA.

        @alerts.select do |finding|
          finding.days_open(as_of) > SLA_DEFINITION[finding.severity]
        end
      end

      def repo_sla_stats(as_of)
        violation_map = sla_violations(as_of)

        # And finally group by the repo
        violation_map.group_by(&:repository).to_h do |repo, findings|
          sum_repo(repo, findings)
        end.with_indifferent_access
      end

      def sla_stats(as_of)
        by_severity = sla_violations(as_of).group_by(&:severity).transform_values(&:size)
        # Because this is just a generalization of the RepoSLAStatisticsCommand, we can gather those results
        # and combine them into a single hash
        base = SLA_DEFINITION.to_h { |severity, _days| [severity, 0] }
        base.merge! by_severity
        totals = { total: base.values.sum } #: { total: Integer }
        base.merge(totals).with_indifferent_access
      end

      def summary(state, severity)
        findings = severity_filter(severity).state_filter(state)
        { count: findings.count }
      end

      def sum_repo(repo, findings)
        by_level = findings.select { |alert| alert.repository == repo }.group_by(&:severity)
        by_level = SLA_DEFINITION.to_h { |key, _count| [key, 0] }.merge(by_level.transform_values(&:count))

        [repo.to_s, { **by_level, total: by_level.values.sum }]
      end

      def select(&)
        self.class.new(@alerts.select(&))
      end

      def severity_filter(severity)
        severity ? select { |alert| alert.security_advisory.severity == severity.to_sym } : self
      end

      def state_filter(state)
        state ? select { |alert| alert.state == state.to_sym } : self
      end

      def where_package(package_name)
        select do |alert|
          alert.dependency.package == package_name
        end
      end
    end
  end
end
