require 'spec_helper'

RSpec.describe GeneratesUid do
  subject(:generator) { described_class.new(args) }
  let(:args) {
    {
      strategy: "default",
      name: "name",
    }
  }

  describe "#initialize" do
    it "sets :strategy attribute" do
      expect(generator.strategy).to eq("default")
    end

    it "sets :name attribtue" do
      expect(generator.name).to eq("name")
    end

    it "errors with no strategy" do
      new_args = args.reject { |k,_| k == :strategy }
      expect { described_class.new(new_args) }.to raise_error
    end

    shared_examples_for "sets default name" do
      it do
        expect(generator.name).to eq("file")
      end
    end

    context "with no :name set" do
      before { args.delete(:name) }
      it_behaves_like "sets default name"
    end

    context "nil :name passed" do
      before { args[:name] = nil }
      it_behaves_like "sets default name"
    end

    context "empty string :name passed" do
      before { args[:name] = "" }
      it_behaves_like "sets default name"
    end

    context "with special characters in name" do
      before { args[:name] = " dirty_file##@2$®¶áname.pdf" }
      it "sanitizes the name" do
        expect(generator.name).to eq("dirty-file-2-name.pdf")
      end
    end

    context "with a really long name" do
      before { args[:name] = "A" * 257 + "B" * 256 }
      it "truncates the beginning of the filename" do
        name = generator.name
        expect(name.size).to eq(512)
        expect(name.count("A")).to eq(name.count("B"))
      end
    end

    context "with an invalid name" do
      before { args[:name] = "$®¶á" }
      it_behaves_like "sets default name"
    end
  end

  describe "#call" do
    subject(:uid) { generator.call }
    let(:uid_segments) { uid.split("/") }

    context "with static time" do
      let(:time) { Time.local(2010, 3, 5, 12, 55, 10) }

      before do
        Timecop.freeze(time)
      end

      after do
        Timecop.return
      end

      it "prefixes path with the current date in segments" do
        expect(uid_segments[0]).to eq("2010")
        expect(uid_segments[1]).to eq("03")
        expect(uid_segments[2]).to eq("05")
      end
    end

    it "generates a uuid for the next segment" do
      expect(uid_segments[3]).to match(/^\w{8}-\w{4}-\w{4}-\w{4}-\w{12}$/)
    end

    it "uses the value of @name for the last component" do
      expect(uid_segments[4]).to eq("name")
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