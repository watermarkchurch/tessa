# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GeneratesUid do
  subject(:generator) { described_class.new(args) }
  let(:args) do
    {
      path: ':year/:uuid',
      user: 'steve',
      name: 'name'
    }
  end
  UUID_REGEX = /^\w{8}-\w{4}-\w{4}-\w{4}-\w{12}$/.freeze

  describe '#initialize' do
    it 'sets :path attribute' do
      expect(generator.path).to eq(':year/:uuid')
    end

    it 'sets :name attribtue' do
      expect(generator.name).to eq('name')
    end

    it 'sets :user attribute' do
      expect(generator.user).to eq('steve')
    end

    shared_examples_for 'sets default name' do
      it do
        expect(generator.name).to eq('file')
      end
    end

    context 'with no :name set' do
      before { args.delete(:name) }
      it_behaves_like 'sets default name'
    end

    context 'with no :path set' do
      before { args.delete(:path) }

      it 'sets to DEFAULT_PATH' do
        expect(generator.path).to eq(described_class::DEFAULT_PATH)
      end
    end

    context 'with :path set to nil' do
      before { args[:path] = nil }

      it 'sets to DEFAULT_PATH' do
        expect(generator.path).to eq(described_class::DEFAULT_PATH)
      end
    end

    context 'with no :user set' do
      before { args.delete(:user) }

      it "sets to 'nouser'" do
        expect(generator.user).to eq('nouser')
      end
    end

    context 'with :user set to nil' do
      before { args[:user] = nil }

      it "sets to 'nouser'" do
        expect(generator.user).to eq('nouser')
      end
    end

    context 'nil :name passed' do
      before { args[:name] = nil }
      it_behaves_like 'sets default name'
    end

    context 'empty string :name passed' do
      before { args[:name] = '' }
      it_behaves_like 'sets default name'
    end

    context 'with special characters in name' do
      before { args[:name] = ' dirty_file##@2$®¶áname.pdf' }
      it 'sanitizes the name' do
        expect(generator.name).to eq('dirty-file-2-name.pdf')
      end
    end

    context 'with a really long name' do
      before { args[:name] = 'A' * 257 + 'B' * 256 }
      it 'truncates the beginning of the filename' do
        name = generator.name
        expect(name.size).to eq(512)
        expect(name.count('A')).to eq(name.count('B'))
      end
    end

    context 'with an invalid name' do
      before { args[:name] = '$®¶á' }
      it_behaves_like 'sets default name'
    end
  end

  describe '#call' do
    subject(:uid) { generator.call }
    let(:uid_segments) { uid.split('/') }

    context 'with default :path' do
      before { args.delete(:path) }

      context 'with static time' do
        let(:time) { Time.local(2010, 3, 5, 12, 55, 10) }

        before do
          Timecop.freeze(time)
        end

        after do
          Timecop.return
        end

        it 'prefixes path with the current date in segments' do
          expect(uid_segments[0]).to eq('2010')
          expect(uid_segments[1]).to eq('03')
          expect(uid_segments[2]).to eq('05')
        end
      end

      it 'generates a uuid for the next segment' do
        expect(uid_segments[3]).to match(UUID_REGEX)
      end

      it 'uses the value of @name for the last component' do
        expect(uid_segments[4]).to eq('name')
      end
    end

    context 'with custom path' do
      let(:date) { Date.new(2010, 3, 5) }
      let(:path) { ':user/:year/:month/:day/:uuid/:name/:unknown' }
      subject(:uid) { generator.call(date: date) }
      before { args[:path] = path }

      it 'substitutes each component and leaves unknowns' do
        user, year, month, day, uuid, name, unknown = uid.split('/')
        expect(user).to eq('steve')
        expect(year).to eq('2010')
        expect(month).to eq('03')
        expect(day).to eq('05')
        expect(uuid).to match(UUID_REGEX)
        expect(name).to eq('name')
        expect(unknown).to eq(':unknown')
      end
    end

    context 'with a name containing an extension' do
      let(:date) { Date.new(2010, 3, 5) }
      subject(:uid) { generator.call(date: date) }

      before do
        args[:name] = 'name.pdf'
        args[:path] = ':year:extension'
      end

      it 'sets :extension to the extension' do
        expect(uid).to eq('2010.pdf')
      end
    end
  end

  describe '::call' do
    it 'calls new with the arguments and then #call returning the result' do
      obj = double(:obj)
      expect(described_class).to receive(:new).with(path: :arg).and_return(obj)
      expect(obj).to receive(:call).and_return(:return_val)
      expect(described_class.call(path: :arg)).to eq(:return_val)
    end

    it 'passes :date option to call but not new if present' do
      obj = double(:obj)
      expect(described_class).to receive(:new).with(path: :arg).and_return(obj)
      expect(obj).to receive(:call).with(date: :date)
      described_class.call(path: :arg, date: :date)
    end

    it "passes today's date to call if no date present" do
      obj = double(:obj)
      expect(described_class).to receive(:new).with(path: :arg).and_return(obj)
      expect(obj).to receive(:call).with(date: Date.today)
      described_class.call(path: :arg)
    end
  end
end
