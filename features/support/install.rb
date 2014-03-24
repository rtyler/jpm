
Before '@install-success' do
  JPM::Catalog.any_instance.should_receive(:install)
end
