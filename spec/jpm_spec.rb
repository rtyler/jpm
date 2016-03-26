require 'spec_helper'
require 'jpm'

describe JPM do
  describe '.installed?' do
    subject { described_class.installed? }
    before :each do
      expect(described_class).to receive(:home_dir).and_return(home_dir)
    end

    context 'without Jenkins' do
      let(:home_dir) { nil }
      it { is_expected.to be false }
    end

    context 'with Jenkins' do
      let(:home_dir) { '/var/lib/jenkins' }
      it { is_expected.to be_truthy }
    end
  end

  describe '.home_dir' do
    subject(:home_dir) { described_class.home_dir }

    context "when a jenkins user doesn't exist" do
      before :each do
        expect(File).to receive(:expand_path).and_raise(ArgumentError)
      end

      it { is_expected.to be_nil }
    end

    context 'when a jenkins user does exist' do
      let(:home) { '/rspec/jenkins' }

      before :each do
        expect(File).to receive(:expand_path).and_return(home)
      end

      it { is_expected.to eql home }
    end
  end

  describe '.has_plugins?' do
    subject(:exists) { described_class.has_plugins? }
    before :each do
      allow(JPM).to receive(:plugins_dir).and_call_original
    end

    context 'if jenkins does not exist' do
      before :each do
        allow(JPM).to receive(:home_dir).and_return(nil)
      end

      it { is_expected.to be false }
    end

    context 'if jenkins exists' do
      let(:home) { '/var/lib/jenkins' }
      let(:dir_exists) { false }

      before :each do
        allow(JPM).to receive(:home_dir).and_return(home)
        expect(File).to receive(:directory?).with(File.join(home, 'plugins')).and_return(dir_exists)
      end

      context 'and the directory exists' do
        let(:dir_exists) { true }
        before :each do
          expect(Dir).to receive(:entries).and_return(entries)
        end

        context 'but is empty' do
          let(:entries) { ['.', '..'] }
          it { is_expected.to be false }
        end

        context 'and has plugins' do
          let(:entries) { ['.', '..', 'ant'] }
          it { is_expected.to be true }
        end
      end

      context 'and the directory does not exist' do
        it { is_expected.to be false }
      end
    end
  end

  describe '.plugins' do
    subject(:plugins) { described_class.plugins }

    context 'when plugins do not exist' do
      before :each do
        expect(described_class).to receive(:has_plugins?).and_return(false)
      end

      it { is_expected.to be_empty }
      it { is_expected.to be_instance_of Array }
    end

    context 'when plugins exist' do
      it 'should generate a list of plugins' do
        pending 'This is too hard to unit test, feh.'
        raise
      end
    end
  end
end
