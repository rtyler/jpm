Given(/^Jenkins isn't installed$/) do
  JPM.stub(:installed? => false)
end

Given(/^Jenkins is installed$/) do
  JPM.stub(:installed? => true)
end

Given(/^there are no plugins available$/) do
  JPM.stub(:plugins => [])
end

Given(/^there are plugins available$/) do
  JPM.stub(:has_plugins? => true)
  JPM.stub(:plugins => [
    {
      :name => 'greenballs',
      :version => '1.0'
    },
    {
     :name => 'ant',
     :version => '1.1'
    },
  ])
end
