# frozen_string_literal: true

module DBotQuery
  module Models
    # A singular package (such as a npm package, a gem, or a pip for python) that is the target of a dependency
    # relationship from a repository.  This is the code that would have a vulnerability.
    class Package < Base
      attribute :name, :string
      attribute :ecosystem, :string

      def ==(other)
        case other
        when Package
          name == other.name && ecosystem == other.ecosystem
        when String
          name == other
        else
          false
        end
      end
    end
  end
end
