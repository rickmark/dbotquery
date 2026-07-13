# frozen_string_literal: true
# rbs_inline: enabled

module DBotQuery
  module Commands
    # Abstract base class that all commands derive from.  This ensures that they handle the JSON and command line
    # correctly.  Each command has a basic flow:
    # * The command is instantiated with the proper arguments passed to the `new` call
    # * The command has `#execute` called (common to all commands) which will call the abstract method `#perform`,
    #   which produces the proper hash for the command.  Execute will then properly format and output the result
    #   to the console.
    class CommandBase
      # The object result of the perform method.  This is prior to serialization allowing composition of commands
      attr_reader :result

      # Abstract initializer
      def initialize
        return if self.class.name != 'DBotQuery::Commands::CommandBase'

        raise NotImplementedError, 'Cannot instantiate an abstract class directly'
      end

      # The shared implementation of the command, which handles calling the abstract method, then formatting for the
      # screen.  This permits the abstract method to be called in unit testing without reliance on the console.
      # As every command operates on the same input file, this is handled as a parameter here.  This permits common
      # error handling such as if the file does not exist or fails to parse.
      #
      # @param  [String] file    The path to the input file
      # @return void
      def execute!(file)
        file_path = Pathname.new(file)

        raise DBotQuery::Error, "File #{file} does not exist" unless file_path.exist? && file_path.file?

        input = read_input file_path

        @result = perform(input)

        puts JSON.pretty_generate(@result)
      end

      # Abstract method that performs the work of the command.
      #
      # @abstract
      # @return Hash
      def perform(_input)
        raise NotImplementedError, '#perform is abstract and must be implemented in derived classes'
      end

      private

      def read_input(file_path)
        input = JSON.load_file(file_path.to_s, freeze: true, symbolize_names: true)

        JSON::Validator.validate!(DBotQuery.schema, input)

        input
      rescue JSON::ParserError => e
        raise DBotQuery::Error, "File #{file_path} is not valid JSON: #{e.message}"
      end
    end
  end
end
