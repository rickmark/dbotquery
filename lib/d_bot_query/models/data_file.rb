# frozen_string_literal: true

module DBotQuery
  module Models
    # Data file.  Reads and parses JSON data.
    class DataFile
      attr_reader :alerts, :data

      def initialize(data)
        JSON::Validator.validate!(DBotQuery.schema, data)
        @data = data
        @alerts = AlertCollection.new(data)
      end

      def self.load(json_data)
        from_data json_data
      end

      def self.load_file(file_path)
        from_data file_path, loader_method: :load_file
      end

      def self.from_data(data, loader_method: :load)
        new JSON.send(loader_method, data, freeze: true)
      rescue JSON::ParserError => e
        raise DBotQuery::Error, "File #{data} is not valid JSON: #{e.message}"
      end
    end
  end
end
