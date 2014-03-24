
Before '@install-success' do
  JPM::Catalog.any_instance.stub(:install).and_return(true)
end
