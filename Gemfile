source 'https://rubygems.org'

# Include the dependencies from the gemspec
gemspec

group :test do
  gem 'rspec'
  gem 'cucumber'
  gem 'aruba'
  gem 'ci_reporter'
  gem 'rspec-its'
end

group :development do
  gem 'rake'
  gem 'pry'
  gem 'debugger', :platform => :mri
  gem 'debugger-pry', :platform => :mri

  gem 'vagrant', :github => 'mitchellh/vagrant',
                 :ref => 'v1.5.1',
                 :platform => :mri
end

group :plugins do
  gem 'vagrant-aws', :platform => :mri
end
