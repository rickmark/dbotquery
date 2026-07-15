module DBotQuery
  module Models
    class CVSSSeverity < Base
      attribute :type, :symbol
      attribute :cvss, CVSS

      def initialize(item)
        super({ type: item[0], cvss: item[1] })
      end
    end
  end
end
