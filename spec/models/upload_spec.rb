require 'spec_helper'

RSpec.describe Upload do

  describe "#initialize" do

    context "with all attributes set" do
      let(:attrs) {
        {
          "strategy" => "temp",
          "acl" => "public",
          "name" => "foo.txt",
          "size" => "3",
          "mime_type" => "text/plain",
        }
      }
      let(:upload) { described_class.new(attrs) }

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
      let(:upload) { described_class.new }

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
    it "calls :asset_factory with all params"
    it "defaults :asset_factory to CreatesAsset"
    it "returns true on success"
    it "returns false on failure"
  end

  describe "#to_json" do
    it "returns an upload_url"
    it "returns an upload_method"
    it "returns a success_url"
    it "returns a cancel_url"
  end
end
