# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rambo}
  s.version = "0.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Richard Taylor"]
  s.date = %q{2010-12-30}
  s.description = %q{rambo is an experimental ruby web framework}
  s.email = %q{moomerman@gmail.com}
  s.files = ["README", "lib/rambo.rb"] + Dir.glob('lib/rambo/**/*.rb')
  s.has_rdoc = false
  s.homepage = %q{http://github.com/moomerman/rambo}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rambo}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{rambo is an experimental ruby web framework based on rack}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<thin>, [">= 1.2.4"])
    else
      s.add_dependency(%q<thin>, [">= 1.2.4"])
    end
  else
    s.add_dependency(%q<thin>, [">= 1.2.4"])
  end
end
