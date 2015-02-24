require 'spec_helper'

RSpec.describe CreatesAsset do

  describe "#initialize" do
    subject(:creates_asset) { CreatesAsset.new(args) }

    shared_examples_for "generates uid" do
      it "generates uid with UIDGenerator"
    end

    context "with all args passed" do
      let(:args) {
        {
          strategy: "mystrat",
          acl: "private",
          uid: "uid/123",
          meta: { "foo" => "bar" },
          dataset: :dataset
        }
      }

      it "sets :strategy attribute" do
        expect(creates_asset.strategy).to eq("mystrat")
      end

      it "sets :acl attribute" do
        expect(creates_asset.acl).to eq("private")
      end

      it "sets :meta attribute" do
        expect(creates_asset.meta).to eq({ "foo" => "bar" })
      end

      it "sets :dataset attribute" do
        expect(creates_asset.dataset).to eq(:dataset)
      end

      it "sets :uid attribute" do
        expect(creates_asset.uid).to eq("uid/123")
      end
    end

    context "with no args passed" do
      let(:args) { {} }

      it "sets :strategy to 'default'" do
        expect(creates_asset.strategy).to eq("default")
      end

      it "sets :acl to 'private'" do
        expect(creates_asset.acl).to eq("private")
      end

      it "sets :dataset to DB[:assets]" do
        expect(creates_asset.dataset).to eq(DB[:assets])
      end

      it "sets :meta to {}" do
        expect(creates_asset.meta).to eq({})
      end

      it "sets :uid to GeneratesUid.(strategy)" do
        uid_generator_args = {
          strategy: "default",
          name: "filename.txt",
        }
        args[:meta] = { "name" => "filename.txt" }
        expect(GeneratesUid).to receive(:call).with(uid_generator_args).and_return(:my_uid)
        expect(creates_asset.uid).to eq(:my_uid)
      end
    end
  end

  describe "#call" do
    subject(:creates_asset) { described_class.new(dataset: dataset, uid: uid) }
    let(:dataset) { double(:dataset, insert: 12345) }
    let(:uid) { 'my_uid' }
    let(:record) {
      {
        strategy: 'default',
        acl: 'private',
        uid: uid,
        meta: {},
        status_id: 1,
      }
    }

    it "calls insert on the dataset with mapped fields" do
      expect(dataset).to receive(:insert).with(record)
      creates_asset.call
    end

    it "only runs once per instance" do
      expect(dataset).to receive(:insert).once
      asset_1 = creates_asset.call
      asset_2 = creates_asset.call
      expect(asset_1.object_id).to eq(asset_2.object_id)
    end

    describe "return value" do
      subject(:asset) { creates_asset.call }

      it "is an Asset instance" do
        expect(asset).to be_a(Asset)
      end

      it "has values set" do
        expect(asset.id).to eq(12345)
        expect(asset.strategy).to eq(record[:strategy])
        expect(asset.acl).to eq(record[:acl])
        expect(asset.uid).to eq(record[:uid])
        expect(asset.meta).to eq(record[:meta])
      end
    end
  end

  describe "::call" do
    it "calls new with the arguments and then #call returning the result" do
      obj = double(:obj)
      expect(described_class).to receive(:new).with(:args).and_return(obj)
      expect(obj).to receive(:call).and_return(:return_val)
      expect(described_class.call(:args)).to eq(:return_val)
    end
  end

end
