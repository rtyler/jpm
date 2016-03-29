
Before '@install-success' do
  expect(JPM::Catalog).to receive(:download) { true }
end
