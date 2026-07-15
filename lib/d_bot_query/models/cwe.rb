# frozen_string_literal: true

module DBotQuery
  module Models
    class CWE < Base
      attribute :cwe_id
      alias_attribute :id, :cwe_id
      attribute :name
    end
  end
end
