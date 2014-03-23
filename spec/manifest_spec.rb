require 'spec_helper'
require 'jpm/manifest'

describe JPM::Manifest do
  describe 'from_manifest' do
    subject(:data) { described_class.from_manifest(data_str) }

    context 'with a plugin version that is hyphenated' do
      let(:data_str) do
        '
Plugin-Version: 1.7.2-1
Jenkins-Version: 1.456
'
      end

      it 'should have the properly hyphenated plugin version' do
        expect(data[:plugin_version]).to eql('1.7.2-1')
      end
    end

    context 'with "standard" looking manifest data' do
      let(:data_str) do
        '
Manifest-Version: 1.0
Archiver-Version: Plexus Archiver
Created-By: Apache Maven
Built-By: jglick
Build-Jdk: 1.7.0_11
Extension-Name: ant
Implementation-Title: ant
Implementation-Version: 1.2
Group-Id: org.jenkins-ci.plugins
Short-Name: ant
Long-Name: Ant Plugin
Url: http://wiki.jenkins-ci.org/display/JENKINS/Ant+Plugin
Plugin-Version: 1.2
Hudson-Version: 1.456
Jenkins-Version: 1.456
Plugin-Developers: 

'
      end

      it { should be_kind_of Hash }

      it 'should parse the right plugin version' do
        expect(data[:plugin_version]).to eql('1.2')
      end
    end

    context 'with a more complex manifest' do
      let(:data_str) do
        '
Manifest-Version: 1.0
Archiver-Version: Plexus Archiver
Created-By: Apache Maven
Built-By: nicolas
Build-Jdk: 1.7.0_45
Extension-Name: git
Specification-Title: Integrates Jenkins with GIT SCM
Implementation-Title: git
Implementation-Version: 2.0.1
Group-Id: org.jenkins-ci.plugins
Short-Name: git
Long-Name: Jenkins GIT plugin
Url: http://wiki.jenkins-ci.org/display/JENKINS/Git+Plugin
Plugin-Version: 2.0.1
Hudson-Version: 1.480
Jenkins-Version: 1.480
Plugin-Dependencies: promoted-builds:2.7;resolution:=optional,token-ma
 cro:1.5.1;resolution:=optional,ssh-credentials:1.5.1,scm-api:0.1,cred
 entials:1.9.3,multiple-scms:0.2;resolution:=optional,parameterized-tr
 igger:2.4;resolution:=optional,git-client:1.6.0
Plugin-Developers: Kohsuke Kawaguchi:kohsuke:,Nicolas De Loof:ndeloof:
 nicolas.deloof@gmail.com

'
      end

      it { should be_kind_of Hash }
      it 'should have the right number of keys' do
        expect(data.keys.size).to eql(18)
      end
    end
  end
end

