Given(/^I have catalog meta\-data$/) do
  allow(JPM).to receive(:repository_path) do
    File.expand_path(File.dirname(__FILE__) + '/../../spec/fixtures/update-center.json')
  end
end

Given(/^an update\-center\.json doesn't already exist$/) do
  # Found in Aruba::Api
  cd('.') do

    # Relative path, since our Dir.pwd will be tmp/aruba already
    repo = './update-center.json'
    allow(JPM).to receive(:repository_path) { repo }

    # If the thing exists already, nuke it!
    if File.exists? repo
      File.unlink repo
    end
  end
end

Given(/^an update\-center\.json already exists$/) do
  # Found in Aruba::Api
  cd('.') do

    # Relative path, since our Dir.pwd will be tmp/aruba already
    repo = './update-center.json'
    allow(JPM).to receive(:repository_path) { repo }
    File.open(repo, 'w+') do |fd|
      fd.write("\n{}\n")
    end
  end
end

Given(/^I have a site with a custom update\-center\.json$/) do
  # Relative path, since our Dir.pwd will be tmp/aruba already
  repo = './update-center.json'
  allow(JPM).to receive(:repository_path) { repo }

  # If the thing exists already, nuke it!
  if File.exists? repo
    File.unlink repo
  end

  response = double('Mock HTTPResponse', :body => '')

  expect(JPM).to receive(:fetch).with('http://aruba.bdd/update-center.json') { response }
end

