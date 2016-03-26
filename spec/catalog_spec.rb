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

  describe '#compute' do
    let(:fixture) { File.expand_path(File.dirname(__FILE__) + '/fixtures/update-center.json') }
    let(:catalog) { described_class.from_file(fixture) }
    subject(:computed_list) { catalog.compute(plugins) }

    context 'with an empty or nil argument' do
      let(:plugins) { [] }
      it { is_expected.to be_empty }
    end

    context 'with a plugin which has no dependencies' do
      let(:plugins) { ['greenballs'] }

      it { is_expected.not_to be_empty }
      its(:size) { should eql 1 }

      it 'should have an instance of JPM::Plugin<greenballs>' do
        plugin = computed_list.first
        expect(plugin).to be_instance_of JPM::Plugin
        expect(plugin.name).to eql 'greenballs'
      end
    end

    context 'with a plugin which has dependencies' do
      # Depends on `credentials`
      let(:plugins) { ['ssh-credentials'] }

      it { is_expected.not_to be_empty }
      its(:size) { should eql 2 }

      it 'should have the right JPM::Plugins computed' do
        expect(computed_list.first).to be_instance_of JPM::Plugin
        expect(computed_list.first.name).to eql 'credentials'
        expect(computed_list.last.name).to eql 'ssh-credentials'
      end
    end

    context 'with a plugin which has nested dependencies' do
      # Depends on ssh-credentials -> credentials
      let(:plugins) { ['git-client'] }

      it { is_expected.not_to be_empty }
      its(:size) { should eql 3 }
    end
  end

  describe '#download' do
    let(:plugin) do
      p = JPM::Plugin.new
      p.name = 'rspec'
      p.url = 'http://rspec.jpi'
      p
    end

    subject(:installation) { catalog.send(:download, plugin) }

    it 'fetch the url from the plugin' do
      response = double('Mock HTTPResponse',
                        :body => '',
                        :code => 200)
      expect(JPM).to receive(:fetch).with(plugin.url).and_return(response)
      expect(catalog).to receive(:save_plugin).and_return(true)

      expect(installation).to be_true
    end
  end

  describe '.from_file' do
    subject(:catalog) { described_class.from_file(fixture) }

    context 'with a valid fixtured update-center.json' do
      let(:fixture) { File.expand_path(File.dirname(__FILE__) + '/fixtures/update-center.json') }

      it { is_expected.to be_instance_of described_class }
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
