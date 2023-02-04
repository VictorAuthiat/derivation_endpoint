# frozen_string_literal: true

require "spec_helper"

RSpec.describe DerivationEndpoint::Serializer do
  describe ".encode" do
    subject { described_class.encode(data) }

    context "with invalid data" do
      let(:data) { "foo" }

      it "raise ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "with invalid data" do
      let(:data) { 1 }

      it "raise ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "with invalid data" do
      let(:data) { :foo }

      it "raise ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "with valid data" do
      let(:data)      { { foo: :bar } }
      let(:json_data) { JSON.generate(data) }

      it "generates encoded base64 url" do
        expect(Base64).to(
          receive(:urlsafe_encode64)
            .with(json_data, padding: false)
            .exactly(1)
            .times
        )

        subject
      end
    end
  end

  describe ".decode" do
    subject { described_class.decode(data) }

    context "with invalid data" do
      let(:data) { 1 }

      it "raise ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "with invalid data" do
      let(:data) { :foo }

      it "raise ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "with valid data but invalid json" do
      let(:data) { "foo" }

      it "raise JSON::ParserError" do
        expect { subject }.to raise_error(JSON::ParserError)
      end
    end

    context "with valid data" do
      let(:data)        { Base64.urlsafe_encode64(JSON.generate({ foo: :bar })) }
      let(:base64_data) { Base64.urlsafe_decode64(data) }

      it "generates encoded base64 url" do
        expect(JSON).to(
          receive(:parse)
            .with(base64_data)
            .exactly(1)
            .times
        )

        subject
      end
    end
  end
end
