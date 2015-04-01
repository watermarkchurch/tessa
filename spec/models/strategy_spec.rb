require 'spec_helper'

RSpec.describe Strategy do
  subject(:strategy) { described_class.new(args) }
  let(:args) {
    {
      name: "default",
      bucket: "my-bucket",
      acl: 'public-read',
      prefix: "prefix/",
      region: "us-east-2",
      credentials: { access_key_id: "abc", secret_access_key: "123" },
      ttl: 1,
      path: ":year/:uuid",
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
        expect(strategy.acl).to eq('public-read')
      end

      it "sets :prefix to attribute" do
        expect(strategy.prefix).to eq("prefix/")
      end

      it "sets :region to attribute" do
        expect(strategy.region).to eq("us-east-2")
      end

      it "sets :credentials to attribute" do
        expect(strategy.credentials).to be_a(Aws::Credentials)
        expect(strategy.credentials.access_key_id).to eq("abc")
        expect(strategy.credentials.secret_access_key).to eq("123")
      end

      it "sets :ttl to attribute" do
        expect(strategy.ttl).to eq(1)
      end

      it "sets :path to attribute" do
        expect(strategy.path).to eq(":year/:uuid")
      end
    end

    context "with Aws::Credentials object for creds" do
      let(:aws_creds) { Aws::Credentials.new("key", "secret") }
      before { args[:credentials] = aws_creds }
      it "uses that cred object" do
        expect(strategy.credentials).to eq(aws_creds)
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
        expect(strategy.acl).to eq('private')
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
  end

  describe "#client" do
    let(:client) { Aws::S3::Client }

    it "calls Aws::S3::Client with config" do
      config = {
        region: strategy.region,
        credentials: strategy.credentials,
      }
      expect(client).to receive(:new).with(config).and_return(:val)
      expect(strategy.client).to eq(:val)
    end

    it "caches the value" do
      expect(strategy.client.object_id).to eq(strategy.client.object_id)
    end
  end

  describe "#resource" do
    let(:resource) { Aws::S3::Resource }

    it "calls Aws::S3::Resource with client" do
      expect(resource).to receive(:new).with(client: strategy.client).and_return(:val)
      expect(strategy.resource).to eq(:val)
    end

    it "caches the value" do
      expect(strategy.resource.object_id).to eq(strategy.resource.object_id)
    end
  end

  describe "#object" do
    it "fetches the object off of the #resource" do
      bucket = double(:bucket)
      expect(strategy.resource)
        .to receive(:bucket).with(strategy.bucket).and_return(bucket)
      expect(bucket).to receive(:object).with('prefix/uid/1').and_return(:object)
      expect(strategy.object('uid/1')).to eq(:object)
    end
  end

  describe "::strategies" do
    it "returns a Hash" do
      expect(described_class.strategies).to be_a(Hash)
    end

    it "caches the Hash" do
      expect(described_class.strategies.object_id)
        .to eq(described_class.strategies.object_id)
    end
  end

  describe "::add" do
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
