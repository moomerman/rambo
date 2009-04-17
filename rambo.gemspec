# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rambo}
  s.version = "0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Richard Taylor"]
  s.date = %q{2009-04-17}
  s.description = %q{rambo is an experimental ruby web framework}
  s.email = %q{moomerman@gmail.com}
  s.files = ["README", "lib/rambo.rb", "lib/rambo", "lib/rambo/base_controller.rb", "lib/rambo/lock.rb", "lib/rambo/server.rb", "lib/rambo/proxy.rb", "lib/rambo/request.rb", "lib/rambo/response.rb", "lib/rambo/templating.rb", "lib/rambo/time.rb", "lib/rambo/upload.rb"]
  s.has_rdoc = false
  s.homepage = %q{http://github.com/moomerman/rambo}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rambo}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{rambo is an experimental ruby web framework}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<oauth>, [">= 0.3.1"])
      s.add_runtime_dependency(%q<json>, [">= 1.1.2"])
    else
      s.add_dependency(%q<oauth>, [">= 0.3.1"])
      s.add_dependency(%q<json>, [">= 1.1.2"])
    end
  else
    s.add_dependency(%q<oauth>, [">= 0.3.1"])
    s.add_dependency(%q<json>, [">= 1.1.2"])
  end
end
