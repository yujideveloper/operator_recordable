# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "operator_recordable/version"

Gem::Specification.new do |spec| # rubocop:disable Metrics/BlockLength
  spec.name          = "operator_recordable"
  spec.version       = OperatorRecordable::VERSION
  spec.authors       = ["Yuji Hanamura"]
  spec.email         = ["yuji.developer@gmail.com"]

  spec.summary       = <<~SUMMARY.tr("\n", " ")
    OperatorRecordable is a Rails plugin to set created_by, updated_by, and
    deleted_by to ActiveRecord objects.
  SUMMARY
  spec.description   = <<~DESC.tr("\n", " ") # rubocop:disable Layout/ExtraSpacing, Layout/SpaceAroundOperators
    OperatorRecordable is a Rails plugin that makes your ActiveRecord models
    to be saved or logically deleted with automatically set created_by,
    updated_by, and deleted_by. Also it makes creator, updater, deleter
    belongs_to association if a class has created_by, updated_by, or
    deleted_by.
  DESC
  spec.homepage      = "https://github.com/yujideveloper/operator_recordable"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"]      = spec.homepage
  spec.metadata["source_code_uri"]   = spec.homepage
  spec.metadata["changelog_uri"]     = "https://github.com/yujideveloper/operator_recordable/tree/main/CHANGELOG.md"

  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.5"

  spec.add_dependency "activerecord", ">= 5.2"
  spec.add_development_dependency "appraisal", ">= 2.3.0"
  spec.add_development_dependency "bundler", ">= 1.16"
  spec.add_development_dependency "discard", ">= 1.2"
  spec.add_development_dependency "pry", ">= 0.10.0"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "rspec", "~> 3.7"
  spec.add_development_dependency "rubocop", ">= 1.13.0"
  spec.add_development_dependency "sqlite3", ">= 1.3.13"
end
