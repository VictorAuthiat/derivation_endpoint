# frozen_string_literal: true

module DerivationEndpoint
  class Derivation
    def self.decode(params)
      DerivationEndpoint.config.decoder.call(params)
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
