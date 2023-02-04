# frozen_string_literal: true

module DerivationEndpoint
  class Attacher
    attr_reader :object, :method, :prefix, :options

    def initialize(object, method, prefix, options)
      Validation.check_object_class(prefix, [String, Symbol, NilClass])
      Validation.check_object_class(options, [Hash, NilClass])

      @object  = object
      @method  = method
      @prefix  = prefix
      @options = options
    end

    def derivation_path
      DerivationEndpoint.config.encoder.call(method_value)
    end

    def redirection_url
      DerivationEndpoint.config.decoder.call(derivation_path, options)
    end

    def method_value
      object.public_send(method)
    end

    def derivation_url
      base_url  = DerivationEndpoint.base_url
      final_url = prefix ? "#{base_url}/#{prefix}" : base_url

      "#{final_url}/#{derivation_path}"
    end
  end
end
