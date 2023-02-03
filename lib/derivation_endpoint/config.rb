# frozen_string_literal: true

module DerivationEndpoint
  class Config
    DEFAULT_PREFIX = "derivation_endpoints".freeze

    attr_reader :host, :encoder, :decoder

    def initialize
      @host    = nil
      @prefix  = nil

      @encoder, @decoder = proc {}
    end

    def prefix
      @prefix || DEFAULT_PREFIX
    end

    def host=(value)
      Validation.check_object_class(value, [String])

      @host = value
    end

    def prefix=(value)
      Validation.check_object_class(value, [String])

      @prefix = value
    end

    def encoder=(value)
      Validation.check_object_class(value, [Proc])

      @encoder = value
    end

    def decoder=(value)
      Validation.check_object_class(value, [Proc])

      @decoder = value
    end
  end
end
