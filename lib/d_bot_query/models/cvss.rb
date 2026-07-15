# frozen_string_literal: true

module DBotQuery
  module Models
    # CVSS vector and score (Common Vulnerability Scoring System)
    class CVSS < Base
      attribute :vector_string, :string
      attribute :score, :float
    end
  end
end
