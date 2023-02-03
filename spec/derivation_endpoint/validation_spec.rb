require "spec_helper"

RSpec.describe DerivationEndpoint::Validation do
  describe ".check_object_class" do
    it "detects invalid arguments", aggregate_failures: true do
      expect { described_class.check_object_class(nil, [NilClass]) }.not_to raise_error
      expect { described_class.check_object_class(nil, [NilClass, Array, Hash]) }.not_to raise_error
      expect { described_class.check_object_class(1, [String]) }.to raise_error(ArgumentError)
      expect { described_class.check_object_class(1, [Integer]) }.not_to raise_error
      expect { described_class.check_object_class(:foo, [String]) }.to raise_error(ArgumentError)
      expect { described_class.check_object_class(:foo, [Symbol]) }.not_to raise_error
      expect { described_class.check_object_class("bar", [Symbol]) }.to raise_error(ArgumentError)
      expect { described_class.check_object_class("bar", [String]) }.not_to raise_error
      expect { described_class.check_object_class("baz", [Hash]) }.to raise_error(ArgumentError)
      expect { described_class.check_object_class({}, [Hash]) }.not_to raise_error
      expect { described_class.check_object_class("buz", [Array]) }.to raise_error(ArgumentError)
      expect { described_class.check_object_class([], [Array]) }.not_to raise_error
    end
  end
end
