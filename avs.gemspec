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
  s.add_development_dependency('rdoc')
  s.add_runtime_dependency('dotenv', '~> 3.1.0')
  s.add_runtime_dependency('gli', '~> 2.21.1')
  s.add_runtime_dependency('mail', '~> 2.8.1')
  s.add_runtime_dependency('pg', '~> 1.5.6')
end
