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

  context "#initialize" do
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

  context "#object" do
    it "calls strategy.object with uid" do
      url.object
      expect(strategy).to have_received(:object).with(uid)
    end

    it "caches the returned object" do
      expect(strategy).to receive(:object).and_return({})
      expect(url.object.object_id).to eq(url.object.object_id)
    end
  end

end
