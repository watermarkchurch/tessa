require 'spec_helper'

RSpec.describe Persistence do
  subject(:persistence) { described_class.new(args) }
  let(:model) {
    Class.new do
      attr_reader :args
      def initialize(args)
        @args = args
      end
    end
  }
  let(:dataset) {
    double(:dataset)
  }
  let(:args) {
    {
      model: model,
      dataset: dataset,
    }
  }

  describe "#initialize" do
    it "sets :model to attribute" do
      expect(persistence.model).to eq(model)
    end

    it "sets :dataset to attribute" do
      expect(persistence.dataset).to eq(dataset)
    end

    context "with no :model set" do
      before { args.delete(:model) }
      it "raises an error" do
        expect { persistence }.to raise_error(ArgumentError)
      end
    end

    context "with no :dataset set" do
      before { args.delete(:dataset) }
      it "raises an error" do
        expect { persistence }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#find" do
    before do
      expect(dataset).to receive(:where).with(id: :find_arg).and_return(dataset)
    end

    it "raises custom error if dataset raises Sequel::NoMatchingRow" do
      expect(dataset).to receive(:first!).and_raise(Sequel::NoMatchingRow)
      expect { persistence.find(:find_arg) }.to raise_error(described_class::RecordNotFound)
    end

    it "returns instance of model if record is found in DB" do
      expect(dataset).to receive(:first!).and_return(:record)
      found = persistence.find(:find_arg)
      expect(found).to be_a(model)
      expect(found.args).to eq(:record)
    end
  end

  describe "#create" do
    let(:instance) { double(:model_instance, valid?: false) }

    before do
      expect(model).to receive(:new).with(:attrs).and_return(instance)
    end

    it "initializes an instance of model with attrs" do
      persistence.create(:attrs)
    end

    shared_examples_for "successful create" do
      subject(:create_call) { persistence.create(:attrs) }

      before do
        expect(instance).to receive(:attributes).and_return(:instance_attrs)
        expect(dataset).to receive(:insert).with(:instance_attrs).and_return(:id)
        expect(instance).to receive(:id=).with(:id)
      end

      it "inserts the value of attributes into the dataset" do
        create_call
      end

      it "sets id on the instance" do
        create_call
      end

      it "returns the instance" do
        expect(persistence.create(:attrs)).to eq(instance)
      end
    end

    context "when instance responds_to valid? and it is true" do
      before { allow(instance).to receive(:valid?).and_return(true) }
      it_behaves_like "successful create"
    end

    context "when instance does not respond_to valid?" do
      let(:instance) { double(:model_instance) }
      it_behaves_like "successful create"
    end

    context "when instance responds_to valid? and it is false" do
      before { allow(instance).to receive(:valid?).and_return(false) }

      it "does not insert into dataset" do
        expect(dataset).to_not receive(:insert)
        persistence.create(:attrs)
      end

      it "returns falsey" do
        expect(persistence.create(:attrs)).to be_falsey
      end
    end
  end

  describe "#update" do
    it "initializes a new instance of model with attrs merged onto attributes"

    shared_examples_for "successful update" do
      it "updates the record matching id with attrs in dataset"
      it "returns the new instance"
    end

    context "when new instance responds_to valid? and it is true" do
      it_behaves_like "successful update"
    end

    context "when new instance doesn't respond_to valid?" do
      it_behaves_like "successful update"
    end

    context "when new instance responds_to valid? and it is false" do
      it "does not update the record in the dataset"
      it "returns falsey"
    end
  end

  describe "#delete" do
    it "calls delete for this record in the dataset"
    it "returns truthy"
  end
end
