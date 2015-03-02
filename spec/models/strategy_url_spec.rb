require 'spec_helper'

RSpec.describe StrategyURL do
  subject(:url) { described_class.new(args) }
  let(:strategy) { spy(:strategy) }
  let(:uid) { "uid/1" }
  let(:args) {
    {
      strategy: strategy,
      uid: uid,
    }
  }

  describe "#initialize" do
    context "with all args" do
      it "sets :strategy" do
        expect(url.strategy).to eq(strategy)
      end

      it "sets :uid" do
        expect(url.uid).to eq(uid)
      end
    end

    context "no :strategy attr" do
      before { args.delete(:strategy) }
      it "raises error" do
        expect { url }.to raise_error(ArgumentError)
      end
    end

    context "no :uid attr" do
      before { args.delete(:uid) }
      it "raises error" do
        expect { url }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#object" do
    it "calls strategy.object with uid" do
      url.object
      expect(strategy).to have_received(:object).with(uid)
    end

    it "caches the returned object" do
      expect(strategy).to receive(:object).and_return({})
      expect(url.object.object_id).to eq(url.object.object_id)
    end
  end

  shared_examples_for "signed url" do
    let(:object) { spy(:object) }
    before { expect(strategy).to receive(:object).and_return(object) }

    context "with no args" do
      it "calls #presigned_url with method_name and default hash" do
        url.public_send(method)
        expect(object).to have_received(:presigned_url).with(method, {})
      end
    end

    context "with args hash" do
      it "calls #presigned_url with method_name and passed argument" do
        url.public_send(method, foo: 1)
        expect(object).to have_received(:presigned_url).with(method, foo: 1)
      end
    end
  end

  describe "#get" do
    let(:method) { :get }
    include_examples "signed url"
  end

  describe "#put" do
    let(:method) { :put }
    include_examples "signed url"
  end

  describe "#head" do
    let(:method) { :head }
    include_examples "signed url"
  end

  describe "#delete" do
    let(:method) { :delete }
    include_examples "signed url"
  end

  describe "#public" do
    let(:object) { spy(:object) }
    before { expect(strategy).to receive(:object).and_return(object) }

    it "calls #presigned_url with method_name and default hash" do
      url.public
      expect(object).to have_received(:public_url)
    end
  end

end
