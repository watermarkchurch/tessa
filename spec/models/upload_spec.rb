require 'spec_helper'

RSpec.describe Upload do
  subject(:upload) { described_class.new(attrs) }
  let(:attrs) { valid_attrs }
  let(:valid_attrs) {
    {
      "strategy" => "temp",
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
        strategy_name: "temp",
        meta: {
          "name" => "foo.txt",
          "size" => 3,
          "mime_type" => "text/plain",
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
        let(:factory) { -> (args) { nil } }
        it "returns falsey" do
          expect(save_return).to be_falsey
        end
      end
    end
  end

  describe "#to_json" do
    subject(:parsed) { JSON.parse(upload.to_json) }

    context "after #save called" do
      let(:asset) { spy(:asset) }
      let(:asset_url) { spy(:asset_url) }

      before do
        upload.save(asset_factory: -> (args) { asset })
        allow(asset).to receive(:url).and_return(asset_url)
      end

      it "returns an upload_url" do
        expect(asset_url).to receive(:put).and_return("the put URL")
        expect(parsed['upload_url']).to eq("the put URL")
      end

      it "returns an upload_method" do
        expect(parsed['upload_method']).to eq("put")
      end

      it "returns a success_url" do
        expect(parsed['success_url']).to be_truthy
      end

      it "returns a cancel_url" do
        expect(parsed['cancel_url']).to be_truthy
      end
    end

    context "#save hasn't been called" do
      it "raises an exception" do
        expect { upload.to_json }.to raise_error(RuntimeError)
      end
    end

  end
end
