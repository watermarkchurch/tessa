require 'spec_helper'

RSpec.describe Asset do

  describe "#initialize" do
    subject(:asset) { described_class.new(args) }

    context "all attributes set" do
      let(:args) {
        {
          "strategy" => "mystrat",
          "uid" => "some/path/123",
          "acl" => "public",
          "status_id" => 1,
          "meta" => { "foo" => "bar" }
        }
      }

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

    context "no attributes set" do
      let(:args) { {} }
      it "sets :strategy to 'default'" do
        expect(subject.strategy).to eq("default")
      end

      it "sets :acl to 'private'" do
        expect(asset.acl).to eq("private")
      end

      it "sets :status_id to 1" do
        expect(subject.status_id).to eq(1)
      end

      it "sets :meta to an empty hash" do
        expect(subject.meta).to eq({})
      end
    end
  end

end
