require 'spec_helper'
require 'jpm'

describe JPM do
  describe '.installed?' do
    subject { described_class.installed? }
    before :each do
      described_class.should_receive(:home_dir).and_return(home_dir)
    end

    context 'without Jenkins' do
      let(:home_dir) { nil }
      it { should be_false }
    end

    context 'with Jenkins' do
      let(:home_dir) { '/var/lib/jenkins' }
      it { should be_true }
    end
  end

  describe '.home_dir' do
    subject(:home_dir) { described_class.home_dir }

    context "when a jenkins user doesn't exist" do
      before :each do
        File.should_receive(:expand_path).and_raise(ArgumentError)
      end

      it { should be_nil }
    end

    context 'when a jenkins user does exist' do
      let(:home) { '/rspec/jenkins' }

      before :each do
        File.should_receive(:expand_path).and_return(home)
      end

      it { should eql home }
    end
  end

  describe '.has_plugins?' do
    subject(:exists) { described_class.has_plugins? }
    before :each do
      JPM.stub(:plugins_dir).and_call_original
    end

    context 'if jenkins does not exist' do
      before :each do
        JPM.stub(:home_dir).and_return(nil)
      end

      it { should be false }
    end

    context 'if jenkins exists' do
      let(:home) { '/var/lib/jenkins' }
      let(:dir_exists) { false }

      before :each do
        JPM.stub(:home_dir).and_return(home)
        File.should_receive(:directory?).with(File.join(home, 'plugins')).and_return(dir_exists)
      end

      context 'and the directory exists' do
        let(:dir_exists) { true }
        before :each do
          Dir.should_receive(:entries).and_return(entries)
        end

        context 'but is empty' do
          let(:entries) { ['.', '..'] }
          it { should be false }
        end

        context 'and has plugins' do
          let(:entries) { ['.', '..', 'ant'] }
          it { should be true }
        end
      end

      context 'and the directory does not exist' do
        it { should be false }
      end
    end
  end

  describe '.plugins' do
    subject(:plugins) { described_class.plugins }

    context 'when plugins do not exist' do
      before :each do
        described_class.should_receive(:has_plugins?).and_return(false)
      end

      it { should be_empty }
      it { should be_instance_of Array }
    end

    context 'when plugins exist' do
      it 'should generate a list of plugins' do
        pending 'This is too hard to unit test, feh.'
      end
    end
  end
end
