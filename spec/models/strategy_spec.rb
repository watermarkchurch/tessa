require 'spec_helper'

RSpec.describe Strategy do
  subject(:strategy) { described_class.new(args) }
  let(:args) {
    {
      name: "default",
      bucket: "my-bucket",
      acl: "public",
      prefix: "prefix/",
      region: "us-east-2",
      credentials: { "access_key_id" => "abc", :secret_access_key => "123" },
      ttl: 1,
    }
  }

  describe "#initialize" do
    context "all attributes set" do
      it "sets :name to attribute" do
        expect(strategy.name).to eq(:default)
      end

      it "sets :bucket to attribute" do
        expect(strategy.bucket).to eq("my-bucket")
      end

      it "sets :acl to attribute" do
        expect(strategy.acl).to eq(:public)
      end

      it "sets :prefix to attribute" do
        expect(strategy.prefix).to eq("prefix/")
      end

      it "sets :region to attribute" do
        expect(strategy.region).to eq("us-east-2")
      end

      it "sets :credentials to attribute" do
        expect(strategy.credentials)
          .to eq(access_key_id: "abc", secret_access_key: "123")
      end

      it "sets :ttl to attribute" do
        expect(strategy.ttl).to eq(1)
      end
    end

    context "without :prefix attr" do
      before { args.delete(:prefix) }
      it "sets to empty string" do
        expect(strategy.prefix).to eq("")
      end
    end

    context "without :acl attr" do
      before { args.delete(:acl) }
      it "sets to 'private'" do
        expect(strategy.acl).to eq(:private)
      end
    end

    context "without :region attr" do
      before { args.delete(:region) }
      it "sets to 'us-east-1'" do
        expect(strategy.region).to eq("us-east-1")
      end
    end

    context "without :ttl attr" do
      before { args.delete(:ttl) }
      it "sets to 900" do
        expect(strategy.ttl).to eq(900)
      end
    end

    context "without :credentials attr" do
      before { args.delete(:credentials) }
      it "sets to empty Hash" do
        expect(strategy.credentials).to eq({})
      end
    end
  end

  context "::strategies" do
    it "returns a Hash" do
      expect(described_class.strategies).to be_a(Hash)
    end

    it "caches the Hash" do
      expect(described_class.strategies.object_id)
        .to eq(described_class.strategies.object_id)
    end
  end

  context "::add" do
    subject(:subclass) { Class.new(described_class) }
    it "takes a symbol followed by a hash" do
      expect {
        subclass.add(:foo, {})
      }.not_to raise_error
    end

    it "stores the strategy in the strategies Hash" do
      subclass.add('my_strategy', ttl: 100)
      strategy = subclass.strategies[:my_strategy]
      expect(strategy).to be_a(described_class)
      expect(strategy.name).to eq(:my_strategy)
      expect(strategy.ttl).to eq(100)
    end
  end
end
