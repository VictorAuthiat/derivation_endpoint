# frozen_string_literal: true

require "rack"

module DerivationEndpoint
  class Derivation
    class << self
      def decode(params)
        decoded_data = DerivationEndpoint::Serializer.decode(params)
        path         = decoded_data["path"]
        options      = decoded_data["options"].transform_keys(&:to_sym)

        DerivationEndpoint.config.decoder.call(path, options)
      end
    end

    def call(env)
      request = Rack::Request.new(env)

      return handle_request(request) if request.get? || request.head?

      render_error(405, "Method not allowed")
    end

    private

    def handle_request(request)
      params = request.path_info.split("/").last

      return render_success(params) if params

      render_error(404, "Source not found")
    rescue ArgumentError
      render_error(405, "Method not allowed")
    end

    def render_success(params)
      [302, { "Location" => self.class.decode(params) }, []]
    end

    def render_error(status, message)
      [status, { "Content-Type" => "text/plain" }, [message]]
    end
  end
end
