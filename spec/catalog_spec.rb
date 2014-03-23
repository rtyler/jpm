require 'spec_helper'
require 'jpm/catalog'
require 'jpm/errors'

describe JPM::Catalog do
  let(:catalog) { described_class.new }

  describe '#current?' do
  end

  describe '#update!' do
  end

  describe '#<<' do
    subject(:add!) { catalog << plugin }

    context 'without a JPM::Plugin argument' do
      let(:plugin) { nil }
      it 'should raise an error' do
        expect { add! }.to raise_error(ArgumentError)
      end
    end

    context' with a JPM::Plugin' do
      let(:plugin) { JPM::Plugin.new }

      it 'should return itself' do
        expect(add!).to eql(catalog)
      end

      it 'should add the plugin properly' do
        expect(catalog.plugins.size).to eql(0)
        add!
        expect(catalog.plugins.size).to eql(1)
      end
    end
  end

  describe '#search' do
    subject(:search) { catalog.search(term) }
  end

  describe '.from_file' do
    subject(:catalog) { described_class.from_file(fixture) }

    context 'with a valid fixtured update-center.json' do
      let(:fixture) { File.expand_path(File.dirname(__FILE__) + '/fixtures/update-center.json') }

      it { should be_instance_of described_class }
      # Our fixture file currently has 870 plugins in it
      its(:size) { should eql 870 }
    end

    context 'with an empty update-center.json' do
      let(:fixture) { File.expand_path(File.dirname(__FILE__) + '/fixtures/empty-update-center.json') }

      it 'should raise an error' do
        expect { catalog }.to raise_error(JPM::Errors::InvalidCatalogError)
      end
    end

    context 'with an invalid file path' do
      let(:fixture) { '/rspec/fail' }

      it 'should raise an error' do
        expect { catalog }.to raise_error(JPM::Errors::MissingCatalogError)
      end
    end
  end

end
