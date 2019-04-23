$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'acts_as_resource/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'acts_as_resource'
  spec.version     = ActsAsResource::VERSION
  spec.authors     = ['FlowerWrong']
  spec.email       = ['sysuyangkang@gmail.com']
  spec.homepage    = 'https://github.com/zhulux/acts_as_resource'
  spec.summary     = 'Acts As For Active Resource'
  spec.description = 'ActsAsResource is a activeresource gem plugin'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org/'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'kaminari', '~> 1.1'
  spec.add_dependency 'rails', '~> 5.2'

  spec.add_development_dependency 'sqlite3'
end
