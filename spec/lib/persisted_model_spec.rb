require 'spec_helper'

RSpec.describe PersistedModel do
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
end
