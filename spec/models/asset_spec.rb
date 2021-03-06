require 'spec_helper'

RSpec.describe Asset do
  subject(:asset) { described_class.new(args) }
  let(:now) { Time.now }
  let(:args) {
    {
      id: 123,
      strategy_name: "mystrat",
      uid: "some/path/123",
      status_id: 1,
      meta: { "foo" => "bar" },
      username: "bob",
      created_at: now,
      updated_at: now,
    }
  }

  describe "#initialize" do
    context "all attributes set" do
      it "sets :id to attribute" do
        expect(asset.id).to eq(123)
      end

      it "sets :strategy_name to attribute" do
        expect(asset.strategy_name).to eq("mystrat")
      end

      it "sets :uid to attribute" do
        expect(asset.uid).to eq("some/path/123")
      end

      it "sets :status_id to attribute" do
        expect(asset.status_id).to eq(1)
      end

      it "sets :meta to attribute" do
        expect(asset.meta).to eq({ "foo" => "bar" })
      end

      it "sets :username attribute" do
        expect(asset.username).to eq("bob")
      end

      it "sets :created_at to attribute" do
        expect(asset.created_at).to eq(now)
      end

      it "sets :updated_at to attribute" do
        expect(asset.updated_at).to eq(now)
      end
    end

    context "without :id" do
      before { args.delete(:id) }
      it "defaults to nil" do
        expect(asset.id).to be_nil
      end
    end

    context "without :status_id" do
      before { args.delete(:status_id) }
      it "sets to default of 1" do
        expect(asset.status_id).to eq(1)
      end
    end

    context "without :meta" do
      before { args.delete(:meta) }
      it "sets to default of {}" do
        expect(asset.meta).to eq({})
      end
    end
  end

  describe "#status" do
    context "status_id is 1" do
      before { args[:status_id] = 1 }
      it "returns :pending" do
        expect(asset.status).to eq(:pending)
      end
    end

    context "status_id is 2" do
      before { args[:status_id] = 2 }
      it "returns :completed" do
        expect(asset.status).to eq(:completed)
      end
    end

    context "status_id is 3" do
      before { args[:status_id] = 3 }
      it "returns :completed" do
        expect(asset.status).to eq(:cancelled)
      end
    end

    context "status_id is 4" do
      before { args[:status_id] = 4 }
      it "returns :completed" do
        expect(asset.status).to eq(:deleted)
      end
    end
  end

  describe "#valid?" do
    before { args[:strategy_name] = "default" }
    subject(:valid?) { asset.valid? }

    context "with all args" do
      it { is_expected.to be_truthy }
    end

    context "without :strategy_name" do
      before { args.delete(:strategy_name) }
      it { is_expected.to be_falsey }
    end

    context "with :strategy_name of non-existant strategy" do
      before { args[:strategy_name] = "not-a-strategy" }
      it { is_expected.to be_falsey }
    end

    context "without :uid" do
      before { args.delete(:uid) }
      it { is_expected.to be_falsey }
    end
  end

  describe "#strategy" do
    subject(:target) { asset }
    include_examples "strategy lookup method"
  end

  describe "#url" do
    before { args[:uid] = "test/uid/1" }
    let(:strategy) { instance_spy(Strategy) }

    shared_examples_for "returning a StrategyURL" do
      it "is of type StrategyURL" do
        expect(call_url).to be_a(StrategyURL)
      end

      it "sets strategy on URL" do
        expect(call_url.strategy).to eq(strategy)
      end

      it "sets asset's uid on URL" do
        expect(call_url.uid).to eq("test/uid/1")
      end

      it "caches the result" do
        expect(call_url.object_id).to eq(call_url.object_id)
      end
    end

    context "with spy passed" do
      it_behaves_like "returning a StrategyURL"

      def call_url
        asset.url(strategy: strategy)
      end
    end

    context "with no args" do
      subject(:url) { asset.url }

      before do
        expect(asset).to receive(:strategy).and_return(strategy).at_least(1)
      end

      it_behaves_like "returning a StrategyURL"

      def call_url
        asset.url
      end
    end
  end

  describe "::find" do
    it "raises error if asset doesn't exist by this id in DB" do
      expect { described_class.find(0) }.to raise_error(Persistence::RecordNotFound)
    end

    context "with an existing asset" do
      let(:asset) { create(:asset) }

      it "returns an instance of the asset" do
        found = described_class.find(asset.id)
        expect(found).to be_a(described_class)
        expect(found.id).to eq(asset.id)
        expect(found.uid).to eq(asset.uid)
      end
    end
  end
end
