# OperatorRecordable

[![Build Status](https://travis-ci.org/yujideveloper/operator_recordable.svg?branch=master)](https://travis-ci.org/yujideveloper/operator_recordable)
[![Maintainability](https://api.codeclimate.com/v1/badges/aaa0fcd567da9232a847/maintainability)](https://codeclimate.com/github/yujideveloper/operator_recordable/maintainability)

OperatorRecordable is a Rails plugin gem that makes your ActiveRecord models to be saved or logically deleted with automatically set `created_by`, `updated_by`, and `deleted_by`.
Also it makes `creator`, `updater`, and `deleter` `belongs_to` association if a class has `created_by`, `updated_by`, or `deleted_by`.

This gem is inspired by [RecordWithOperator](https://github.com/nay/record_with_operator).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'operator_recordable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install operator_recordable

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yujideveloper/operator_recordable.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
