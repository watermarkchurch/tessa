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

  describe "#query" do
    subject(:result) { persistence.query(query_args) }
    let(:query_args) { { id: [1, 2, 3] } }
    let(:data) { [{}, {}, {}] }
    before do
      expect(dataset).to receive(:where).with(query_args).and_return(data)
    end

    it "returns an array of instances of model" do
      expect(result.size).to eq(3)
      expect(result[0]).to be_a(model)
      expect(result[1]).to be_a(model)
      expect(result[2]).to be_a(model)
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
    subject(:create_call) { persistence.create(attrs) }
    let(:instance) { double(:model_instance, valid?: false) }
    let(:attrs) { {} }

    before do
      expect(model).to receive(:new).with(attrs).and_return(instance)
    end

    it "initializes an instance of model with attrs" do
      create_call
    end

    shared_examples_for "successful create" do
      let(:instance_attributes) { { instance: true } }
      before do
        expect(instance).to receive(:attributes).and_return(instance_attributes).at_least(1)
        allow(dataset).to receive(:insert).with(instance_attributes).and_return(:id)
        expect(instance).to receive(:id=).with(:id)
      end

      it "inserts the value of attributes into the dataset" do
        expect(dataset).to receive(:insert).with(instance_attributes).and_return(:id)
        create_call
      end

      it "sets id on the instance" do
        create_call
      end

      context ":id key is present in instance attributes" do
        let(:instance_attributes) { { id: 1, a: 2 } }
        it "removes :id" do
          expect(dataset).to receive(:insert).with(a: 2).and_return(:id)
          create_call
        end
      end

      context "nil value keys present in instance attributes" do
        let(:instance_attributes) { { a: nil, b: "val" } }

        it "removes nil values" do
          expect(dataset).to receive(:insert).with(b: "val").and_return(:id)
          create_call
        end
      end

      it "returns the instance" do
        expect(create_call).to eq(instance)
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
        create_call
      end

      it "returns falsey" do
        expect(create_call).to be_falsey
      end
    end
  end

  describe "#update" do
    subject(:update_call) { persistence.update(instance, attrs) }
    let(:attrs) { { a: 'new' } }
    let(:instance) {
      double(
        :model_instance,
        id: 123,
        attributes: { id: 123, instance: true, a: 'coerced_new' },
        "attributes=" => nil,
      )
    }

    it "assigns the attributes on the instance" do
      allow(instance).to receive(:valid?).and_return(false)
      expect(instance).to receive(:attributes=).with(attrs)
      update_call
    end

    shared_examples_for "successful update" do
      before do
        expect(dataset).to receive(:where).with(id: 123).and_return(dataset)
        allow(dataset).to receive(:update).and_return(1)
      end

      it "updates the record with instance's values and attrs's keys" do
        expect(dataset).to receive(:update).with(a: 'coerced_new').and_return(1)
        update_call
      end

      context "with :id key in instance attributes" do
        it "removes the :id" do
          expect(instance).to receive(:attributes).and_return(id: 1, a: 2)
          expect(dataset).to receive(:update).with(a: 2).and_return(1)
          update_call
        end
      end

      context "nil value keys present in instance attributes" do
        let(:attrs) { { a: nil, b: "val" } }
        it "does not remove nil values" do
          expect(instance).to receive(:attributes).and_return(a: nil, b: "val")
          expect(dataset).to receive(:update).with(a: nil, b: "val").and_return(:id)
          update_call
        end
      end

      it "passes update return value through" do
        expect(update_call).to eq(1)
      end
    end

    context "when new instance responds_to valid? and it is true" do
      before { expect(instance).to receive(:valid?).and_return(true) }
      it_behaves_like "successful update"
    end

    context "when new instance doesn't respond_to valid?" do
      it_behaves_like "successful update"
    end

    context "when new instance responds_to valid? and it is false" do
      before { expect(instance).to receive(:valid?).and_return(false) }

      it "does not update the record in the dataset" do
        update_call
      end

      it "returns 0" do
        expect(update_call).to eq(0)
      end
    end
  end

  describe "#delete" do
    subject(:delete_call) { persistence.delete(instance) }
    let(:instance) { double(:instance, id: 123) }

    before do
      expect(dataset).to receive(:where).with(id: 123).and_return(dataset).ordered
      expect(dataset).to receive(:delete).and_return(1)
    end

    it "calls delete for this record in the dataset" do
      delete_call
    end

    it "passes on the return value from #delete" do
      expect(delete_call).to eq(1)
    end
  end
end
