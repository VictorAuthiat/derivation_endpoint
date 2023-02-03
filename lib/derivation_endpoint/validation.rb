# frozen_string_literal: true

module DerivationEndpoint
  module Validation
    def self.check_object_class(object, expected_classes = [])
      return if expected_classes.include?(object.class)

      raise ArgumentError, "Expect #{object} class to be #{expected_classes.join(', ')}."
    end

    def self.check_object_responds(object, expected_method)
      return if object.respond_to?(expected_method)

      raise ArgumentError, "Expect #{object} class to respond to #{expected_method}."
    end
  end
end
