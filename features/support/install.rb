
Before '@install-success' do
  JPM::Catalog.any_instance.stub(:download).and_return(true)
end
