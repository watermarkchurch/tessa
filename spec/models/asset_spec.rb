require 'spec_helper'

RSpec.describe Asset do
  subject(:asset) { described_class.new(args) }
  let(:args) {
    {
      id: 123,
      strategy_name: "mystrat",
      uid: "some/path/123",
      status_id: 1,
      meta: { "foo" => "bar" }
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
    subject(:valid?) { asset.valid? }

    context "with all args" do
      it { is_expected.to be_truthy }
    end

    context "without :strategy_name" do
      before { args.delete(:strategy_name) }
      it { is_expected.to be_falsey }
    end

    context "without :uid" do
      before { args.delete(:uid) }
      it { is_expected.to be_falsey }
    end
  end

  describe "#strategy" do
    let(:strategy_class) { Class.new(Strategy) }
    before do
      strategy_class.add :default, {}
    end

    context "with a configured strategy name" do
      subject(:strategy) { asset.strategy(strategy_class) }
      before { args[:strategy_name] = "default" }
      it { is_expected.to be_a(Strategy) }
    end

    context "with an unknown strategy name" do
      subject(:strategy) { asset.strategy(strategy_class) }
      before { args[:strategy_name] = "unknown" }
      it { is_expected.to be_nil }
    end

    context "with default strategy db" do
      subject(:strategy) { asset.strategy }
      before do
        args[:strategy_name] = "test_#{rand(10000)}"
        STRATEGIES.add asset.strategy_name, {}
      end

      it { is_expected.to be_a(Strategy) }
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
