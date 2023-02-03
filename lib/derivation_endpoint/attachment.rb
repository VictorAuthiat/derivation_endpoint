# frozen_string_literal: true

module DerivationEndpoint
  module Attachment
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      ATTACHER_DERIVATION_METHODS = ["derivation_url", "redirection_url"].freeze

      def derivation_endpoint(method, prefix: nil, options: nil)
        Validation.check_object_class(method, [String, Symbol])
        Validation.check_object_class(prefix, [String, Symbol, NilClass])
        Validation.check_object_class(options, [Hash, NilClass])

        define_derivation_methods(method, prefix, options)
      end

      private

      def define_derivation_methods(method, prefix, options)
        ATTACHER_DERIVATION_METHODS.each do |attacher_method|
          define_method(:"#{method}_#{attacher_method}") do
            attacher = Attacher.new(self, method, prefix, options)
            attacher.public_send(attacher_method)
          end
        end
      end
    end
  end
end
