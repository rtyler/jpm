Given(/^I have catalog meta\-data$/) do
  JPM.stub(:repository_path).and_return(
    File.expand_path(File.dirname(__FILE__) + '/../../spec/fixtures/update-center.json'))
end

Given(/^an update\-center\.json doesn't already exist$/) do
  # Relative path, since our Dir.pwd will be tmp/aruba already
  repo = './update-center.json'
  JPM.stub(:repository_path).and_return(repo)

  # If the thing exists already, nuke it!
  if File.exists? repo
    File.unlink repo
  end
end

