# -*- encoding: utf-8 -*-
# stub: hcl-checker 1.0.5 ruby lib

Gem::Specification.new do |s|
  s.name = "hcl-checker".freeze
  s.version = "1.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Marcelo Castellani".freeze]
  s.date = "2018-12-10"
  s.description = "Hashicorp Configuration Language parser and checker for Ruby".freeze
  s.email = ["marcelo.castellani@totvs.com.br".freeze]
  s.files = [".gitignore".freeze, ".rspec".freeze, ".travis.yml".freeze, "CODE_OF_CONDUCT.md".freeze, "Gemfile".freeze, "Gemfile.lock".freeze, "LICENSE.txt".freeze, "README.md".freeze, "Rakefile".freeze, "assets/lexer.rex".freeze, "assets/parse.y".freeze, "bin/console".freeze, "bin/setup".freeze, "hcl-checker.gemspec".freeze, "lib/hcl/checker.rb".freeze, "lib/hcl/checker/version.rb".freeze, "lib/hcl/lexer.rb".freeze, "lib/hcl/parser.rb".freeze]
  s.homepage = "https://github.com/mfcastellani/hcl-checker".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.3".freeze
  s.summary = "Hashicorp Configuration Language parser for Ruby".freeze

  s.installed_by_version = "2.7.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.16"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_development_dependency(%q<racc>.freeze, ["= 1.4.14"])
      s.add_development_dependency(%q<rex>.freeze, ["= 2.0.12"])
      s.add_development_dependency(%q<rexical>.freeze, ["= 1.0.5"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1.16"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_dependency(%q<racc>.freeze, ["= 1.4.14"])
      s.add_dependency(%q<rex>.freeze, ["= 2.0.12"])
      s.add_dependency(%q<rexical>.freeze, ["= 1.0.5"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.16"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<racc>.freeze, ["= 1.4.14"])
    s.add_dependency(%q<rex>.freeze, ["= 2.0.12"])
    s.add_dependency(%q<rexical>.freeze, ["= 1.0.5"])
  end
end
