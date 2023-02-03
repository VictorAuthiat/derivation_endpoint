# frozen_string_literal: true

module DerivationEndpoint
  class Attachment < Module
    ATTACHER_DERIVATION_METHODS = ["derivation_url", "redirection_url"].freeze

    def initialize(column, prefix: nil, options: nil)
      super()

      Validation.check_object_class(column, [String, Symbol])
      Validation.check_object_class(prefix, [String, Symbol, NilClass])
      Validation.check_object_class(options, [Hash, NilClass])

      define_attacher_methods(column, prefix, options)
    end

    def define_attacher_methods(column, prefix, options)
      ATTACHER_DERIVATION_METHODS.each do |attacher_method|
        define_method(:"#{column}_#{attacher_method}") do
          attacher = Attacher.new(self, column, prefix, options)
          attacher.public_send(attacher_method)
        end
      end
    end
  end
end
