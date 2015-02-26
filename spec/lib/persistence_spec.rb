require 'spec_helper'

RSpec.describe Persistence do
  subject(:persisted) { described_class.new(args) }
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
      expect(persisted.model).to eq(model)
    end

    it "sets :dataset to attribute" do
      expect(persisted.dataset).to eq(dataset)
    end

    context "with no :model set" do
      before { args.delete(:model) }
      it "raises an error" do
        expect { persisted }.to raise_error(ArgumentError)
      end
    end

    context "with no :dataset set" do
      before { args.delete(:dataset) }
      it "raises an error" do
        expect { persisted }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#find" do
    before do
      expect(dataset).to receive(:where).with(id: :find_arg).and_return(dataset)
    end

    it "raises custom error if dataset raises Sequel::NoMatchingRow" do
      expect(dataset).to receive(:first!).and_raise(Sequel::NoMatchingRow)
      expect { persisted.find(:find_arg) }.to raise_error(described_class::RecordNotFound)
    end

    it "returns instance of model if record is found in DB" do
      expect(dataset).to receive(:first!).and_return(:record)
      found = persisted.find(:find_arg)
      expect(found).to be_a(model)
      expect(found.args).to eq(:record)
    end
  end

  describe "#create" do
    it "initializes an instance of model with attrs"

    shared_examples_for "successful create" do
      it "inserts the value of attributes into the dataset"
      it "returns the instance"
    end

    context "when instance responds_to valid? and it is true" do
      it_behaves_like "successful create"
    end

    context "when instance does not respond_to valid?" do
      it_behaves_like "successful create"
    end

    context "when instance responds_to valid? and it is false" do
      it "does not insert into dataset"
      it "returns falsey"
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
