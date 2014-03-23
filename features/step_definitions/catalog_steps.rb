Given(/^I have catalog meta\-data$/) do
  JPM.stub(:repository_path).and_return(
    File.expand_path(File.dirname(__FILE__) + '/../../spec/fixtures/update-center.json'))
end

