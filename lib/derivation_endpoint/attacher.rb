# frozen_string_literal: true

module DerivationEndpoint
  class Attacher
    attr_reader :object, :method, :prefix, :options

    def initialize(object, method, prefix, options)
      Validation.check_object_responds(object, method)
      Validation.check_object_class(prefix, [String, Symbol, NilClass])
      Validation.check_object_class(options, [Hash, NilClass])

      @object  = object
      @method  = method
      @prefix  = prefix
      @options = options
    end

    def base_url
      url = DerivationEndpoint.base_url

      prefix ? "#{url}/#{prefix}" : url
    end

    def method_value
      object.public_send(method)
    end

    def derivation_url
      "#{base_url}/#{derivation_path}"
    end

    def derivation_path
      DerivationEndpoint.config.encoder.call(method_value)
    end

    def redirection_url
      DerivationEndpoint.config.decoder.call(derivation_path, options)
    end
  end
end
