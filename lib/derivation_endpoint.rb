# frozen_string_literal: true

require_relative "derivation_endpoint/version"
require_relative "derivation_endpoint/validation"

module DerivationEndpoint
  autoload :Config,     "derivation_endpoint/config"
  autoload :Attacher,   "derivation_endpoint/attacher"
  autoload :Attachment, "derivation_endpoint/attachment"
  autoload :Derivation, "derivation_endpoint/derivation"
  autoload :Serializer, "derivation_endpoint/serializer"

  class << self
    def extended(base)
      base.include(DerivationEndpoint::Attachment)
    end

    def configure
      yield config if block_given?
    end

    def config
      @_config ||= Config.new
    end

    def derivation_path
      return unless config.valid?

      "/#{config.prefix}"
    end

    def base_url
      return unless config.valid?

      config.host + derivation_path
    end
  end
end
