# frozen_string_literal: true

module DerivationEndpoint
  module Validation
    def self.check_object_class(object, expected_classes = [])
      return if expected_classes.include?(object.class)

      raise ArgumentError,
            "Expect #{object} class to be #{expected_classes.join(', ')}."
    end
  end
end
