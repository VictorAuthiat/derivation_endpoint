# frozen_string_literal: true

module DerivationEndpoint
  class Config
    REQUIRED_ATTRIBUTES = [:host, :prefix, :encoder, :decoder].freeze

    def self.valid?(config)
      Validation.check_object_class(config, [self])

      REQUIRED_ATTRIBUTES.all? { |attribute| !!config.public_send(attribute) }
    end

    attr_reader :host, :prefix, :encoder, :decoder

    def initialize
      @host    = nil
      @prefix  = nil
      @encoder = nil
      @decoder = nil
    end

    def valid?
      self.class.valid?(self)
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
