Given(/^Jenkins isn't installed$/) do
  allow(JPM).to receive(:installed?) { false }
end

Given(/^Jenkins is installed$/) do
  allow(JPM).to receive(:installed?) { false }
end

Given(/^there are no plugins available$/) do
  allow(JPM).to receive(:plugins) { [] }
end

Given(/^there are plugins available$/) do
  allow(JPM).to receive(:has_plugins?) { true }
  allow(JPM).to receive(:plugins) do
    [
      {
        :name => 'greenballs',
        :version => '1.0'
      },
      {
       :name => 'ant',
       :version => '1.1'
      },
    ]
  end
end
