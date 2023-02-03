# frozen_string_literal: true

require_relative "derivation_endpoint/version"
require_relative "derivation_endpoint/validation"

module DerivationEndpoint
  autoload :Config,     "derivation_endpoint/config"
  autoload :Attacher,   "derivation_endpoint/attacher"
  autoload :Attachment, "derivation_endpoint/attachment"
  autoload :Derivation, "derivation_endpoint/derivation"

  class << self
    def configure
      yield config if block_given?
    end

    def config
      @_config ||= Config.new
    end

    def host
      config.host
    end

    def prefix
      config.prefix
    end

    def derivation_path
      "/#{prefix}"
    end

    def base_url
      host + derivation_path
    end
  end
end
