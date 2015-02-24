require 'spec_helper'

RSpec.describe Asset do

  describe "#initialize" do
    subject(:asset) { described_class.new(args) }
    let(:args) {
      {
        strategy: "mystrat",
        uid: "some/path/123",
        acl: "public",
        status_id: 1,
        meta: { "foo" => "bar" }
      }
    }

    context "all attributes set" do
      it "sets :strategy to attribute" do
        expect(asset.strategy).to eq("mystrat")
      end

      it "sets :uid to attribute" do
        expect(asset.uid).to eq("some/path/123")
      end

      it "sets :acl to attribute" do
        expect(asset.acl).to eq("public")
      end

      it "sets :status_id to attribute" do
        expect(asset.status_id).to eq(1)
      end

      it "sets :meta to attribute" do
        expect(asset.meta).to eq({ "foo" => "bar" })
      end
    end

    shared_examples_for "raises argument error" do
      it { expect { asset }.to raise_error(ArgumentError) }
    end

    context "without :strategy" do
      before { args.delete(:strategy) }
      it_behaves_like "raises argument error"
    end

    context "without :uid" do
      before { args.delete(:uid) }
      it_behaves_like "raises argument error"
    end

    context "without :acl" do
      before { args.delete(:acl) }
      it_behaves_like "raises argument error"
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

end
