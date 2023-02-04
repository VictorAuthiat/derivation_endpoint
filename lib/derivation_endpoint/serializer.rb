# frozen_string_literal: true

require "base64"
require "json"

module DerivationEndpoint
  module Serializer
    class << self
      def encode(data)
        Validation.check_object_class(data, [Hash])

        Base64.urlsafe_encode64(JSON.generate(data), padding: false)
      end

      def decode(data)
        Validation.check_object_class(data, [String])

        JSON.parse(Base64.urlsafe_decode64(data))
      end
    end
  end
end
