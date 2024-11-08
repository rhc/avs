# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__), 'lib', 'avs', 'version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'avs'
  s.version = Avs::VERSION
  s.author = 'Christian Kyony'
  s.email = 'ckyony@changamuka.com'
  s.homepage = 'https://github.com/rhc/avs'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A description of your project'
  s.files = `git ls-files`.split(' ')
  s.require_paths << 'lib'
  s.extra_rdoc_files = ['README.adoc', 'avs.rdoc']
  s.rdoc_options << '--title' << 'avs' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'avs'
  s.add_development_dependency('minitest')
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc','6.7.0')
  s.add_runtime_dependency('activesupport', '~> 7.1.3.2')
  s.add_runtime_dependency('connection_pool', '~> 2.4.1')
  s.add_runtime_dependency('dotenv', '~> 3.1.0')
  s.add_runtime_dependency('gli', '~> 2.21.1')
  s.add_runtime_dependency('mail', '~> 2.8.1')
  s.add_runtime_dependency('pg', '~> 1.5.6')
  s.add_runtime_dependency('roo', '~> 2.10.1')
  s.add_runtime_dependency('ruby-progressbar', '~> 1.13.0')
  s.add_runtime_dependency('typhoeus', '~> 1.4.1')
  s.add_runtime_dependency('logger', '~>1.6.1')
  s.add_runtime_dependency('ostruct', '~>0.6.1')
end
