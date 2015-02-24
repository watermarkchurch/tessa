require 'spec_helper'

RSpec.describe Upload do
  subject(:upload) { described_class.new(attrs) }
  let(:attrs) { valid_attrs }
  let(:valid_attrs) {
    {
      "strategy" => "temp",
      "acl" => "public",
      "name" => "foo.txt",
      "size" => "3",
      "mime_type" => "text/plain",
    }
  }

  describe "#initialize" do
    context "with all attributes set" do
      it "sets strategy to attribute" do
        expect(upload.strategy).to eq("temp")
      end

      it "sets acl to attribute" do
        expect(upload.acl).to eq("public")
      end

      it "sets name to attribute" do
        expect(upload.name).to eq("foo.txt")
      end

      it "sets size to attribute" do
        expect(upload.size).to eq(3)
      end

      it "sets mime_type to attribute" do
        expect(upload.mime_type).to eq("text/plain")
      end
    end

    context "with no attributes set" do
      let(:attrs) { {} }

      it "sets strategy to 'default'" do
        expect(upload.strategy).to eq("default")
      end

      it "sets acl to 'private'" do
        expect(upload.acl).to eq("private")
      end

      it "doesn't set name or mime_type" do
        expect(upload.name).to be_nil
        expect(upload.mime_type).to be_nil
      end

      it "sets size to 0" do
        expect(upload.size).to eq(0)
      end
    end
  end

  describe "#save" do
    let(:asset_attrs) {
      {
        strategy: "temp",
        acl: "public",
        meta: {
          name: "foo.txt",
          size: 3,
          mime_type: "text/plain",
        }
      }
    }

    context "with default :asset_factory" do
      it "uses CreatesAsset" do
        asset = double(:asset, id: 123)
        expect(CreatesAsset).to receive(:call).with(asset_attrs).and_return(asset)
        upload.save
      end
    end

    context "with custom :asset_factory" do
      subject(:save_return) { upload.save(asset_factory: factory) }
      let(:factory) { -> (args) { double(:asset, id: 123) } }

      it "calls the factory with all passed args" do
        asset = factory.({})
        expect(factory).to receive(:call).with(asset_attrs).and_return(asset)
        save_return
      end

      it "is idempotent" do
        asset = double(:asset, id: 123)
        expect(factory).to receive(:call).once.and_return(asset)
        upload.save(asset_factory: factory)
        upload.save(asset_factory: factory)
      end

      context "returned asset has an id" do
        it "returns truthy" do
          expect(save_return).to be_truthy
        end
      end

      context "returned asset does not have an id" do
        let(:factory) { -> (args) { double(:asset, id: nil) } }
        it "returns falsey" do
          expect(save_return).to be_falsey
        end
      end
    end
  end

  describe "#to_json" do
    it "returns an upload_url"
    it "returns an upload_method"
    it "returns a success_url"
    it "returns a cancel_url"
  end
end
