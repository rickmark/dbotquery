# frozen_string_literal: true

module DBotQuery
  module Models
    # Generic base class for models.  Provides common functionality for all models.
    # This includes additional scalar type support.
    class Base
      # Provides additional scalar type support for casting to symbols
      class SymbolType < ActiveModel::Type::Value
        def cast(value)
          return nil if value.nil?

          value.to_sym
        end

        def serialize(value)
          value&.to_s
        end
      end

      # Provides additional scalar type support for casting to URLs (including those with templates)
      class URLType < ActiveModel::Type::Value
        def cast(value)
          return nil if value.nil?

          Addressable::Template.new value
        end

        def serialize(value)
          value.pattern.to_s
        end
      end

      # Provides additional scalar type support for casting to arrays of objects (with the target class)
      class ObjectArray < ActiveModel::Type::Value
        attr_reader :target_class

        # Initialize with the specific class you want the array to hold
        def initialize(of:)
          @target_class = of
          super()
        end

        # Casts raw input data (e.g. an array of hashes) into an array of objects
        def cast(value)
          return [] if value.blank?

          # Ensure it's handled like an array
          Array(value).map do |item|
            materialize item
          end
        end

        def serialize(value)
          value.map(&:to_h)
        end

        private

        def materialize(item)
          case item
          when Hash, Array
            target_class.new(item)
          when target_class
            item
          else
            raise "Unexpected data (not of target_type #{target_class} or a Hash)"
          end
        end
      end

      ActiveModel::Type.register(:symbol, SymbolType)
      ActiveModel::Type.register(:url, URLType)
      ActiveModel::Type.register(:array, ObjectArray)

      include ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::Validations
      include ActiveModel::Serialization

      # As the models can be modified and re-serialized, we permit the changing of the data.
      def self.mutable?
        true
      end

      # Run the validations on the model
      def self.assert_valid_value(value)
        case value
        when self
          raise 'value is not valid' unless value.valid?
        when Hash
          invalid = validate_hash_attributes(value)
          raise "#{self} has invalid hash attributes #{invalid.to_a.to_sentence}" unless invalid.empty?
        else
          false
        end
      end

      # Permit the creation of a model from a hash
      def self.cast(input_hash)
        new input_hash
      end

      def to_h
        attributes.to_h do |key, value|
          type_for = self.class.type_for_attribute key
          result = type_for.respond_to?(:serialize) ? type_for.serialize(value) : value
          [key, result]
        end
      end

      # Helper to define multiple attributes of a specific type
      def self.attributes(type, *attributes)
        suffix = type.to_s.downcase
        attributes.each do |attribute|
          self.attribute :"#{attribute}_#{suffix}", type
        end
      end

      def self.validate_hash_attributes(hash)
        attributes = attribute_names.to_set
        keys = hash.keys.to_set(&:to_s)
        invalid_keys = attributes - keys
        keys <= attributes ? [] : invalid_keys.to_a
      end
    end
  end
end
