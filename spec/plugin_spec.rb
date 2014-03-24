require 'spec_helper'
require 'jpm/errors'
require 'jpm/plugin'

describe JPM::Plugin do
  describe '.from_hash' do
    subject(:plugin) { described_class.from_hash(data) }

    context 'with empty data' do
      let(:data) { nil }
      it 'should raise' do
        expect { plugin }.to raise_error(JPM::Errors::InvalidPluginError)
      end
    end

    context 'with invalid data' do
      let(:data) { {} }
      it 'should raise' do
        expect { plugin }.to raise_error(JPM::Errors::InvalidPluginError)
      end
    end

    context 'with real data' do
      let(:data) do
        {"buildDate"=>"Jan 08, 2014",
        "dependencies"=>
          [{"name"=>"promoted-builds", "optional"=>true, "version"=>"2.7"},
          {"name"=>"token-macro", "optional"=>true, "version"=>"1.5.1"},
          {"name"=>"ssh-credentials", "optional"=>false, "version"=>"1.5.1"},
          {"name"=>"scm-api", "optional"=>false, "version"=>"0.1"},
          {"name"=>"credentials", "optional"=>false, "version"=>"1.9.3"},
          {"name"=>"multiple-scms", "optional"=>true, "version"=>"0.2"},
          {"name"=>"parameterized-trigger", "optional"=>true, "version"=>"2.4"},
          {"name"=>"git-client", "optional"=>false, "version"=>"1.6.0"}],
        "developers"=>
          [{"developerId"=>"kohsuke", "name"=>"Kohsuke Kawaguchi"},
          {"developerId"=>"ndeloof",
            "email"=>"nicolas.deloof@gmail.com",
            "name"=>"Nicolas De Loof"}],
        "excerpt"=>
          "This plugin allows use of <a href='http://git-scm.com/'>Git</a> as a build SCM. A recent Git runtime is required (1.7.9 minimum, 1.8.x recommended). Plugin is only tested on official <a href='http://git-scm.com/'>git client</a>. Use exotic installations at your own risks.",
        "gav"=>"org.jenkins-ci.plugins:git:2.0.1",
        "labels"=>["scm"],
        "name"=>"git",
        "previousTimestamp"=>"2013-10-22T22:00:16.00Z",
        "previousVersion"=>"2.0",
        "releaseTimestamp"=>"2014-01-08T21:46:20.00Z",
        "requiredCore"=>"1.480",
        "scm"=>"github.com",
        "sha1"=>"r5bK/IP8soP08D55Xpcx5yWHzdY=",
        "title"=>"Git Plugin",
        "url"=>"http://updates.jenkins-ci.org/download/plugins/git/2.0.1/git.hpi",
        "version"=>"2.0.1",
        "wiki"=>"https://wiki.jenkins-ci.org/display/JENKINS/Git+Plugin"}
      end

      its(:name) { should eql 'git' }
      its(:dependencies) { should_not be_empty }
    end
  end

  describe '#shortform' do
    let(:data) do
      {"buildDate"=>"Jan 08, 2014",
      "dependencies"=>
        [{"name"=>"promoted-builds", "optional"=>true, "version"=>"2.7"},
        {"name"=>"token-macro", "optional"=>true, "version"=>"1.5.1"},
        {"name"=>"ssh-credentials", "optional"=>false, "version"=>"1.5.1"},
        {"name"=>"scm-api", "optional"=>false, "version"=>"0.1"},
        {"name"=>"credentials", "optional"=>false, "version"=>"1.9.3"},
        {"name"=>"multiple-scms", "optional"=>true, "version"=>"0.2"},
        {"name"=>"parameterized-trigger", "optional"=>true, "version"=>"2.4"},
        {"name"=>"git-client", "optional"=>false, "version"=>"1.6.0"}],
      "developers"=>
        [{"developerId"=>"kohsuke", "name"=>"Kohsuke Kawaguchi"},
        {"developerId"=>"ndeloof",
          "email"=>"nicolas.deloof@gmail.com",
          "name"=>"Nicolas De Loof"}],
      "excerpt"=>
        "This plugin allows use of <a href='http://git-scm.com/'>Git</a> as a build SCM. A recent Git runtime is required (1.7.9 minimum, 1.8.x recommended). Plugin is only tested on official <a href='http://git-scm.com/'>git client</a>. Use exotic installations at your own risks.",
      "gav"=>"org.jenkins-ci.plugins:git:2.0.1",
      "labels"=>["scm"],
      "name"=>"git",
      "previousTimestamp"=>"2013-10-22T22:00:16.00Z",
      "previousVersion"=>"2.0",
      "releaseTimestamp"=>"2014-01-08T21:46:20.00Z",
      "requiredCore"=>"1.480",
      "scm"=>"github.com",
      "sha1"=>"r5bK/IP8soP08D55Xpcx5yWHzdY=",
      "title"=>"Git Plugin",
      "url"=>"http://updates.jenkins-ci.org/download/plugins/git/2.0.1/git.hpi",
      "version"=>"2.0.1",
      "wiki"=>"https://wiki.jenkins-ci.org/display/JENKINS/Git+Plugin"}
    end
    let(:plugin) { described_class.from_hash(data) }
    subject(:shortform) { plugin.shortform }

    it { should be_instance_of String }

    context 'with no labels' do
      before :each do
        data['labels'] = nil
      end
      it { should be_instance_of String }
    end
  end
end
