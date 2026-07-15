# frozen_string_literal: true

module DBotQuery
  module Models
    # A single dependency.  Describes the package that has or had a vulnerability that triggered the alert.
    class Dependency < Base
      attribute :package, Package
      attribute :manifest_path
      attribute :scope
    end
  end
end
